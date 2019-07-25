#include <Timer.h>
#include "radiocommunication.h"

configuration mymainC {
}
implementation {
  components MainC;
  components LedsC;
  components mymainP as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_COMMUNICATION_ID);
  components new AMReceiverC(AM_COMMUNICATION_ID);
  components new Atm128I2CMasterC();

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.I2CPacket -> Atm128I2CMasterC;
  App.I2CResource -> Atm128I2CMasterC;
}
