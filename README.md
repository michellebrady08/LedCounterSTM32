## Configuración de GPIO

### Objetivos de la practica

1. Instalar el software para compilar código para el microcontrolador STM32F103.
2. Analizar la estructura de un programa arm escrito para un microcontrolador.
3. Grabar en la tarjeta de desarrollo *blue pill* un programa de pruebas empleando el grabador ST-LINK v2.
4. Modificar el programa de prueba para controlar el encendido de 5 a 10 LED mediante un par de *push button*.

### Instrucciones

En nuevo proyecto, modifica el programa para que ahora se enciendan de cinco a diez LED conectados a los puertos GPIO del µC. Los LED deben mostrar el valor binario de una variable. Si se oprime un *push button* A, entonces se debe incrementar el valor de la variable en una unidad. Si se oprime un *push button* B, entonces el valor de la variable debe decrementarse. Si se oprimen los dos botones, entonces el valor de la variable debe mantenerse. Es importante realizar el diagrama electrónico del circuito.

### Descripción de los archivos del proyecto

Los archivos que componen la platilla de proyecto de programación *baremetal* se describen enseguida.

Los archivos con extensión INC contienen mnemónicos de direcciones de memoria que sustituyen la dirección base de alguna sección de algún periférico o la compensación (*offset*) que debe sumarse a la dirección base para alcanzar algún registro de configuración en particular.

Los archivos con extensión S contienen código ensamblador ARM escrito en sintaxis GAS. Todas las funciones contenidas en estos archivos son declaradas como globales para que éstas puedan ser visibles por otros funciones contenidas en otros archivos durante el proceso de enlace.:

### main.s

La función `__main` está contenida en este archivo. Por omisión, está función siempre es invocada por la subrutina de restablecimiento. El código ensamblador de la función `__main` configura 10 pines de la tarjeta blue pill para actuar como un contador binario, con la ayuda de 2 push buttons que van a actuar de forma en que si se presiona el boton A el contador haga un incremento de la cuenta, iluminando los leds,  en caso de que se presione el boton B se haga un decremento, y finalmente al presionar ambos botones se mantenga la cuenta.

Se configuran 10 pines del 15 al 6 para servir de salidas para encender los leds, y los pines 0 y 3 para servir como entradas para los push buttons.

En el bucle de main lo que se realiza va a realizar va a ser un constante chequeo del estado de ambos botones para que en el caso de que un boton este presionado este cumpla con su función. De forma más especifica se realiza lo siguiente.

Primero se manda como argumentos la direccion base añadida con el offset de nuestro boton, se manda los lsl y el and que se tiene que realizar para poder aislar nuestro bit, y leer unicamente el valor de este, con esto se llama a la función de is_button_pressed, esta regresa el valor del pin.

Se hace una comparacion para determinar el valor retornado por la función, en caso de que se haya retornado un 1 se procede a checar el segundo boton, en caso de que este tambien este presionado (o sea con valor 1) se mantiene el valor del contador, en caso contrario se hace la suma. En caso de que el valos de la primera comparación retorne un 0, se checa el segundo boton y en caso de que este este encendido, se hace la resta, en caso contrario se repite el bucle. 

La lógica de los botones se puede apreciar mejor en el siguiente diagrama.

![image](https://github.com/michellebrady08/LedCounterSTM32/assets/110513243/866f759d-b1eb-4fc0-ac40-bd4e99122731)

# Diagrama de conecciones

![L5](https://github.com/michellebrady08/LedCounterSTM32/assets/110513243/9372d369-8782-4d6d-8e1a-e1be387b2de4)

# Compiling directives
Make

st-flash write 'prog.bin' 0x8000000

Make clean
