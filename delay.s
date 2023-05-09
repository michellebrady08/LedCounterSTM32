.cpu cortex-m3      
.section .text
.align	1
.syntax unified
.thumb
.global delay

delay:
        # Prologue
        push    {r7} 
        sub     sp, sp, #20 
        add     r7, sp, #0 
        # back arg
        str     r0, [r7] 

        mov     r0, #255 
        str     r0, [r7, #16]
# for (i = 0; i < ms; i++)
        mov     r0, #0 
        str     r0, [r7, #8]
        b       F3
# for (j = 0; j < tick; j++)
F4:     mov     r0, #0 
        str     r0, [r7, #12]
        b       F5
F6:     ldr     r0, [r7, #12]           @ j++;
        add     r0, #1
        str     r0, [r7, #12]
F5:     ldr     r0, [r7, #12]           @ j < ticks;
        ldr     r1, [r7, #16]
        cmp     r0, r1
        blt     F6
        ldr     r0, [r7, #8]            @ i++;
        add     r0, #1
        str     r0, [r7, #8]
F3:     ldr     r0, [r7, #8]            @ i < ms
        ldr     r1, [r7]
        cmp     r0, r1
        blt     F4
        # Epilogue
        adds    r7, r7, #20
        mov	    sp, r7
        pop	    {r7}
        bx	    lr
.size	delay, .-delay