/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */
#include "altera_avalon_pio_regs.h"

#define ENPin 0b1
#define DIRPin 0b10

int delay(int n){
      unsigned int delay = 0 ;
      while(delay < n){
          delay++;
      }
      return 0;
}

void putSteps(int steps){

	for(unsigned int i = 0; i < steps; i++){

	}
}

volatile int edge_capture;
volatile unsigned int pins;

void handle_button_interrupts(void* context, alt_u32 id)
 {
    /* Cast context to edge_capture's type. It is important that this be
      * declared volatile to avoid unwanted compiler optimization.
      */
     volatile int* edge_capture_ptr = (volatile int*) context;
     /* Store the value in the Button's edge capture register in *context. */
     *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE);
     pins = IORD_32DIRECT(PIO_1_BASE, 0);

     /* Reset the Button's edge capture register. */
     IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE, 0);
 }

void init_pio()
 {
     /* Recast the edge_capture pointer to match the alt_irq_register() function
      * prototype. */
     void* edge_capture_ptr = (void*) &edge_capture;
     /* Enable first four interrupts. */
     IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_1_BASE, 0xf);
     /* Reset the edge capture register. */
     IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE, 0x0);
     /* Register the interrupt handler. */
     alt_irq_register( PIO_1_IRQ, edge_capture_ptr,
                       handle_button_interrupts );
 }

unsigned int vel[] = {16000, 8000, 4000, 2000};

int main(void){
  init_pio();
  int led = 0;
  printf("Embarcados++ \n");
  int count = 0;
  int diff = 0;
  int prevCommd = 0;
  int actDelay = 16000;
  while(1){
	  int commd = (pins >> 2) & 0b11;
	  if(pins & ENPin){
		  IOWR_32DIRECT(PIO_0_BASE, 0, 0x01 << led);
		  led += (pins & DIRPin)? 1 : -1;
		  if (led > 3){
			  led = 0;
		  }else if(led < 0){
			  led = 3;
		  }
		  if(prevCommd != commd){
			  diff = vel[prevCommd] - vel[commd];
			  actDelay = vel[commd] + diff;
			  prevCommd = commd;
		  }else if(diff != 0){
			  if(count > 20){
				  count = 0;
				  diff /= 1.3;
				  actDelay = vel[commd] + diff;
			  }
			  count++;
		  }
		  usleep(actDelay);
	  }
  };

  return 0;
}




