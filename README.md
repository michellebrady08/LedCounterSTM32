# Compiling directives
Make
st-flash write 'prog.bin' 0x8000000
Make clean

# Led Counter STM32F103C8T6 baremetal

El código alojado en este repositorio se emplea como base para desarrollar proyectos de software *baremetal*, escritos desde cero en lenguaje arm, bajo la sintaxis del GNU Assembler (GAS). El término «programación *baremetal*» hace referencia al hecho de desarrollar programas que serán ejecutados en un microcontrolador (µC) sin asistencia de un sistema operativo u otra capa de software que abstraiga la complejidad del hardware. Este tipo de programación se emplea para desarrollar aplicaciones de alto rendimiento que aprovechan al máximo los limitados recursos de cómputo propios de un µC. 

Académicamente, la programación *baremetal* permite que los estudiantes adquieran conocimientos profundos sobre la arquitectura del µC, entendiendo el término «arquitectura» como «*las relaciones estructurales que no son visibles al programador* [de lenguajes de alto nivel de abstracción], *tales como interfaces a los periféricos* [y sus registros de configuración], *la frecuencia del reloj o la tecnología usada por la memoria*» (Murdocca, 2007). Además, este tipo de programación permite experimentar directamente con el proceso de ensamble y enlace, los cuales se ven oscurecidos al compilar código escrito en C, por ejemplo.

El proceso de ensamble es aquel que consiste en traducir código arm en código máquina. Este código tiene la particularidad de tener una longitud de 16 bits porque está codificado según el conjunto `Thumb`. Este código tiene la ventaja de requerir poco espacio de almacenamiento.

El enlace es el proceso que consiste en unir el código máquina contenido en diferentes objetos para crear un programa ejecutable. El programa que realiza el
enlace se llama enlazador. El enlace puede ser estático o dinámico y resulta en un archivo ELF que indica cómo el código máquina debe almacenarse en la memoria de instrucciones o en la memoria de datos.

## Motivación

Esta plantilla de proyecto es necesaria porque mucha de la documentación sobre ARM se presenta siguiendo la sintaxis propia del ensamblador privado (ARM assembly syntax) y no en GAS. Asimismo, existen muchos recursos virtuales en la web que permiten comenzar un proyecto de software, pero estos se codifican en C empleando la capa de abstracción de hardware de STM32 bajo un entorno de desarrollo integrado (IDE) como el STM32CubeIDE que ofrece todos los archivos necesarios para poder compilar, ensamblar y escribir un µC STM32. Estos recursos disponibles son de alto valor; sin embargo, no cubren la necesidad de aquellos que requieren comenzar un proyecto de software para un µC empleando herramientas de compilación libres.

En el libro «Embedded Systems with ARM Cortex-M Microcontrollers in Assembly Language and C» (Zhi, 2018) se explican diversos fragmentos de código, todos estos escritos con la sintaxis propia de ARM. En el apéndice A del libro antes referenciado se encuentra una explicación útil sobre similitudes entre la sintaxis del GAS y del ensamblador ARM. No obstante, esta explicación puede no ser suficiente para que un principiante que está comenzando a comprender la relación entre el lenguaje ensamblador y la arquitectura de los µC arm Cortex-M3 pueda comenzar un proyecto *baremetal* por su cuenta.

En GitHub y en Youtube se encuentran recursos que pueden emplearse para comenzar un proyecto de software *baremetal*. El código publicado en el repositorio stm32-asm-samples en por el usuario @lapers se emplea como base la generación de esta plantilla de proyecto. Además, el *script* de configuración del enlazador está basado en el código presentado en video «Bare metal embedded lecture-4: Writing linker scripts and section placement», publicado el canal FastBit Embedded Brain Academy.

## Descripción de los archivos del proyecto

Los archivos que componen la platilla de proyecto de programación *baremetal* se describen enseguida. 

Los archivos con extensión INC contienen mnemónicos de direcciones de memoria que sustituyen la dirección base de alguna sección de algún periférico o la compensación (*offset*) que debe sumarse a la dirección base para alcanzar algún registro de configuración en particular.

Los archivos con extensión S contienen código ensamblador ARM escrito en sintaxis GAS. Todas las funciones contenidas en estos archivos son declaradas como globales para que éstas puedan ser visibles por otros funciones contenidas en otros archivos durante el proceso de enlace.:

### afio_map.inc

Este archivo contiene las directivas que relaciones la dirección base de los registros de configuración de la funciones alternas de entrada y salida (AFIO, *Alternate Function Input/Output*). Entre varias utilidades, estos registros permite configurar las interrupciones externas.

### blink.s

La función `__main` está contenida en este archivo. Por omisión, está función siempre es invocada por la subrutina de restablecimiento. El código ensamblador de la función `__main` configura el pin trece de la tarjeta *blue pill* para que se encienda y apague cada segundo. A este comportamiento de encendido y apagado intermitente se le conoce como parpadeo (*blink*).

El pin trece de la tarjeta *blue pill* tiene conectado un led azul integrado en la propia tarjeta. Este led está conectado en modo ánodo, esto implica que éste se enciende si se escribe el bit trece del registro y `GPIOC_ODR` con cero. Para lograr que el led parpadee, en la función `__main` se invoca iterativamente a una función llamada `ddelay` que provoca un retraso de un segundo, aproximadamente. Cada que pasa un segundo, el bit trece del registro `GPIOC_ODR` se complementa.

### default_handler.s

La rutina de servicio de interrupción (ISR, *interrupt service routine*) de restablecimiento se encuentra alojada en este archivo. Esta rutina se invoca cada que el µC se restablece. Su código debe extenderse para inicializar las localidades de memoria de la sección de datos, la cual aloja las variables estáticas declaradas en lenguajes de alto nivel.

### delay.s

Aquí se define la función `ddelay`, la cual produce un retardo aproximado de un segundo vía software. El nombre *ddelay* hace referencia al término *dirty delay* (retraso sucio) debido a que impide que el procesador del µC realice alguna otra tarea mientras el tiempo del retraso transcurre. En su lugar, es conveniente generar los retrasos mediante interrupciones para permitir que el procesador continúe realizando otras tareas.

### exti_map.inc

### gpio_map.inc

### main.s

### nvic_reg_map.inc

### rcc_map.inc

### scb_map.inc

### systick_map.inc

### stm32f103c8t6.ld

## Ensamble

## Enlace

## Escritura del código en el µC
