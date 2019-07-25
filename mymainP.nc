#include <Timer.h>
#include "radiocommunication.h"

module mymainP {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0; //I2C based data collection
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Resource as I2CResource;
  uses interface I2CPacket<TI2CBasicAddr>; //address size is 7bits <TI2C7Bit>
}
implementation {
 
  uint8_t measurement_start_register = 0x0F, measured_value[2], slave_address = 0x10;
  uint16_t* value16;
  message_t pkt;
  bool busy = FALSE;

	task void doI2Cstuff();

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(2000); //do measurements periodically every 2000 ms
      //call Timer1.startPeriodic(53);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() 
	{
		post doI2Cstuff();
  }

  task void doI2Cstuff()
  {
		error_t resOK;
    
		resOK = call I2CResource.immediateRequest();
    if(resOK == SUCCESS)
    {
	    //do stuff
call Leds.led2Toggle();
	    call I2CPacket.write(I2C_START, slave_address, 1, &measurement_start_register);
		}
		else ;//didn't get I2C resourc, use I2CResource.request() or try again next round
  }

  task void send_data()
  {
    if (!busy) {
      tempValues16* tmppkt = (tempValues16*)(call Packet.getPayload(&pkt, sizeof(tempValues16)));
      if (tmppkt == NULL)
			{
				return;
      }

			value16 = (uint16_t*)measured_value;
      tmppkt->t1 = *value16;
      tmppkt->t2 = 0;
			tmppkt->t3 = 0;
			tmppkt->t4 = 0;
			tmppkt->t5 = 0;

      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(tempValues16)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  task void releaseresource()
	{
		call I2CResource.release();
	}

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event void I2CResource.granted(){}
  
  async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data)
  {
    if(error == SUCCESS)//successfully read data from slave
    {
      //store this data somewhere and read more data; or send data over radio immediately
			post send_data();

    }
			//don't forget to release resource if you're done with I2C for now
      post releaseresource();
  }

  async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data)
  {
    if(error == SUCCESS)//successfully wrote data to slave
    {
      //read from slave
      call Leds.led1Toggle();
			call I2CPacket.read(0, slave_address, 2, measured_value);
    }
		else post releaseresource();
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    return msg;
  }
}
