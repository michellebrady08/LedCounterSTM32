
.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "delay.s"
.include "isButtonPressed.s"
.include "gpio_map.inc"
.include "rcc_map.inc"

.section .text
.align 1
.syntax unified
.thumb
.global __main

__main:

        push	{r7, lr}                                @ create frame
	sub	sp, sp, #8
	add	r7, sp, #0  

        # enabling clock in port B
        ldr     r0, =RCC_BASE                      @ move 0x40021018 to r0
        mov     r3, #0x8                                @ loads 8 in r1 to enable clock in port B (IOPB bit)
        str     r3, [r0, RCC_APB2ENR_OFFSET]                                @ M[RCC_APB2ENR] gets 8

        # set pin 8-15 as digital output
        ldr     r0, =GPIOB_BASE                      @ moves address of GPIOB_CRH register to r0
        ldr     r3, =0x33333333                         @ PB15 output push-pull, max speed 50 MHz
        str     r3, [r0, GPIOx_CRH_OFFSET]                                @ M[GPIOB_CRH] gets 

        # set pin 6-7 as digital input and pin 0 and 3 as digital input
        ldr     r3, =0x33448448                         @ PB0: input
        str     r3, [r0, GPIOx_CRL_OFFSET]
        # conf
        mov     r3, #0
        str     r3, [r0, GPIOx_ODR_OFFSET]

        mov     r3, 0x1                                @ counter initial value 
        str     r3, [r7, #4]

loop:
        ldr     r0, =GPIOB_BASE
        add     r0, GPIOx_IDR_OFFSET
        mov     r1, #0
        mov     r2, #1
        bl      is_button_pressed
        cmp     r0, #0
        bne     _check
        ldr     r0, =GPIOB_BASE
        add     r0, GPIOx_IDR_OFFSET
        mov     r1, #3
        mov     r2, #8
        bl      is_button_pressed
        cmp     r0, #0
        bne     _sub
        mov     r3, 0x0
        b       ep
_check:
        ldr     r0, =GPIOB_BASE
        add     r0, GPIOx_IDR_OFFSET
        mov     r1, #3
        mov     r2, #8
        bl      is_button_pressed
        cmp     r0, #0
        bne     _stop

_add:   ldr     r3, [r7, #4]
        add     r3, r3, #1
        str     r3, [r7, #4]
        lsls     r3, r3, #6
        b       ep

_stop:  ldr     r3, [r7, #4]
        lsls    r3, r3, #6
        b       ep
_sub:
        ldr     r3, [r7, #4]
        sub     r3, r3, #1
        str     r3, [r7, #4]
        lsls     r3, r3, #6
        b       ep     

ep:     ldr     r0, =GPIOB_BASE
        str     r3, [r0, GPIOx_ODR_OFFSET]
        mov     r0, #1000
        bl      delay
        b       loop





