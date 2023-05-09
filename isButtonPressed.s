.cpu cortex-m3      
.section .text
.align	1
.syntax unified
.thumb
.global is_button_pressed

is_button_pressed:
	    push	{r7, lr}                @ create frame
	    sub	    sp, sp, #24
	    add	    r7, sp, #0
    # store funtion arguments
        str     r0, [r7, #12]           @ stores pin address
        str     r1, [r7, #8]            @ stores lsr
        str     r2, [r7, #4]            @ stores and 
    # read button
        ldr     r0, [r7, #12]           @ pin address         
        ldr     r0, [r0]                @ obtain value
        ldr     r1, [r7, #4]            @ load and   
        and     r0, r1                  
        ldr     r1, [r7, #8]            @ load lsr
        lsr     r0, r1 
        cmp     r0, #0                  @ if (!is_button_pressed)
        bne     D1                      @ else 
    # return 0
        mov     r0, #0                  @ return false
        b       _ep                     @ jumps to epilogue
D1:     mov     r3, #0                  @ counter = 0
        str     r3, [r7, #16]
        mov     r3, #0                  @ i = 0
        str     r3, [r7, #20]
        b       D2                      @ jumps to for loop
D3:     mov     r0, #5                  @ wait 5ms
        bl      delay
    # read button
        ldr     r0, [r7, #12]           
        ldr     r0, [r0]
        ldr     r1, [r7, #4]
        and     r0, r1
        ldr     r1, [r7, #8]
        lsr     r0, r1 
        cmp     r0, #0                  @ if (!is_button_pressed)
        bne     D4                      @ else
        mov     r3, #0                  @ counter = 0
        str     r3, [r7, #16]           
D4:     ldr     r3, [r7, #16]           @ load counter
        add     r3, r3, #1              @ counter ++
        str     r3, [r7, #16]   
        cmp     r3, #4                  @ if( counter >= 4)
        blt     D5                      @ else
        mov     r0, #1                  @ return true
        b       _ep         
D5:     ldr     r3, [r7, #20]           @ load i
        add     r3, r3, #1              @ i++
        str     r3, [r7, #20]       
D2:     ldr     r3, [r7, #20]           @ load i
        cmp     r3, #10                 @ i<10
        blt     D3
        mov     r0, #0                  @ return false
    # epilogo
_ep:    adds    r7, r7, #24
	    mov	    sp, r7
	    pop	    {r7, pc}

.size	is_button_pressed, .-is_button_pressed