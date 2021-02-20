;Archivo:	7segmentos.s
;Dispositivo:	    PIC16F887
;Autor:	    Juan Diego Villafuerte
;Compilador: pic-as (v2.30), MPLABX V5.40
;
;Programa:	Timer0 con 500ms y contador hex con 7 segmentos
;Hardware:	LEDs en puestos C, 7 segmentos en puerto D, botones en puerto B
;
;Creado;	16 febrero 2021
;Ultima modificación:	    16 febrero 2021

PROCESSOR 16F887
#include <xc.inc>
    ;configuration word 1

    CONFIG FOSC=INTRC_NOCLKOUT // Osilador interno sin salida
    CONFIG WDTE=OFF // WDT disabled (reinicio repetitivo del pic)
    CONFIG PWRTE=ON // PWRT eneable (espeera de 72ms al inicial)
    CONFIG MCLRE=OFF // El pin de MCLR se utiliza como I/O 
    CONFIG CP=OFF // Sin proteccion de código
    CONFIG CPD=OFF // Sin proteccion de datos
    
    CONFIG BOREN=OFF //Sin reinicio cuando el voltaje de alimentación baja de 4V
    CONFIG IESO=OFF // Reinicio sin cambio de reloj de interno a externo
    CONFIG FCMEN=OFF // Cambio de reloj externo a interno en caso de fallo
    CONFIG LVP=ON // Programación en bajo voltaje permitida
    
    ;configuration word 2
    
    CONFIG WRT=OFF // Proteccion de autoescritura por el programa desactivada
    CONFIG BOR4V=BOR40V // Reinicio abajo de 4V1 (BOR21V=2.1V)
    
    PSECT udata_bank0 ;common memory
	;inc_cont_1: DS 1 ;1 byte
	;var: DS 5
;_____________________________Para el vector reset______________________________   
    PSECT resVect, class=CODE, abs, delta=2
    OrG 00h	;posicion 0000h para el reset
resetVec:
	PAGESEL Segundo
	goto Segundo
    
    PSECT code, delta=2, abs
    ORG 100h
    
;________________________________Loop del codigo________________________________   

7segmentos:
    banksel ANSELH   ;Movernos al banco de ANSELH
    clrf ANSELH	     ;i/o digitales
    
    banksel TRISB    ;Movernos al banco de TRISx
    bsf TRISB,0      ;Para que PORTB sea input el pin 0 y 1
    bsf TRISB,1	     
    
    clrf TRISC	     ;Puertos de C como output
    clrf TRISD	     ;Puertos de D como output
    clrf TRISE	     ;Puertos de E como output
    
    bsf TRISC,4
    bsf TRISC,5
    bsf TRISC,6
    bsf TRISC,7
    
    bcf OPTION_REG,5 ;Para configurar el reloj interno
    bcf OPTION_REG,3 ;Activar el prescaler para timer0
    
    bsf OPTION_REG,0 ;Cargar el prescaler
    bsf OPTION_REG,1
    bsf OPTION_REG,2

    bcf OSCCON,6
    bcf OSCCON,5
    bsf OSCCON,4
    
    banksel PORTA    ;Movernos al banco de PORTx
    clrf PORTC	     ;Iniciar con los pines apagados
    clrf PORTD
    clrf PORTE
    
    movlw FF
    movfw TMR0
    
timer4bits:
    banksel OPTION_REG
    btfss OPTION_REG,6 
    goto $-1
    call puertoB
    
puertoB:
    incf PORTB
    end
    