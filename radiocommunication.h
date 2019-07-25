#ifndef RADIO_COMMUNICATION_H
#define RADIO_COMMUNICATION_H

#define AM_COMMUNICATION_ID 33

/************************************************************
 *	Radio message structures
 ************************************************************/
//!NB! Max payload size is 110 bytes!

typedef nx_struct tempValues16 {
	nx_uint16_t t1;
	nx_uint16_t t2;
	nx_uint16_t t3;
	nx_uint16_t t4;
	nx_uint16_t t5;
} tempValues16;

typedef nx_struct tempValuesF {
	nx_float t1;
	nx_float t2;
	nx_float t3;
	nx_float t4;
	nx_float t5;
} tempValuesF;

#endif // RADIO_COMMUNICATION_H
