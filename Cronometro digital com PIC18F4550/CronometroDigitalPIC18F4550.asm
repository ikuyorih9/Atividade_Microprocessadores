
_conta:

;CronometroDigitalPIC18F4550.c,4 :: 		void conta(){
;CronometroDigitalPIC18F4550.c,5 :: 		PORTD = bcd[contagem];
	MOVF        _contagem+0, 0 
	MOVWF       R0 
	MOVF        _contagem+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _bcd+0
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_bcd+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;CronometroDigitalPIC18F4550.c,6 :: 		contagem++;
	INFSNZ      _contagem+0, 1 
	INCF        _contagem+1, 1 
;CronometroDigitalPIC18F4550.c,7 :: 		if(contagem > 9)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _contagem+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__conta8
	MOVF        _contagem+0, 0 
	SUBLW       9
L__conta8:
	BTFSC       STATUS+0, 0 
	GOTO        L_conta0
;CronometroDigitalPIC18F4550.c,8 :: 		contagem = 0;
	CLRF        _contagem+0 
	CLRF        _contagem+1 
L_conta0:
;CronometroDigitalPIC18F4550.c,9 :: 		}
L_end_conta:
	RETURN      0
; end of _conta

_INTERRUPCAO_HIGH:

;CronometroDigitalPIC18F4550.c,11 :: 		void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO{
;CronometroDigitalPIC18F4550.c,12 :: 		if(INTCON.INT0IF == 1){
	BTFSS       INTCON+0, 1 
	GOTO        L_INTERRUPCAO_HIGH1
;CronometroDigitalPIC18F4550.c,13 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;CronometroDigitalPIC18F4550.c,15 :: 		T0CON.TMR0ON = 1;
	BSF         T0CON+0, 7 
;CronometroDigitalPIC18F4550.c,16 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;CronometroDigitalPIC18F4550.c,17 :: 		}
L_INTERRUPCAO_HIGH1:
;CronometroDigitalPIC18F4550.c,19 :: 		if(INTCON3.INT1IF == 1){
	BTFSS       INTCON3+0, 0 
	GOTO        L_INTERRUPCAO_HIGH2
;CronometroDigitalPIC18F4550.c,20 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;CronometroDigitalPIC18F4550.c,21 :: 		T0CON.TMR0ON = 0;
	BCF         T0CON+0, 7 
;CronometroDigitalPIC18F4550.c,22 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;CronometroDigitalPIC18F4550.c,23 :: 		}
L_INTERRUPCAO_HIGH2:
;CronometroDigitalPIC18F4550.c,25 :: 		if(INTCON.TMR0IF == 1){
	BTFSS       INTCON+0, 2 
	GOTO        L_INTERRUPCAO_HIGH3
;CronometroDigitalPIC18F4550.c,26 :: 		PORTA.RA0 ^= 1;
	BTG         PORTA+0, 0 
;CronometroDigitalPIC18F4550.c,27 :: 		conta();
	CALL        _conta+0, 0
;CronometroDigitalPIC18F4550.c,28 :: 		TMR0H = 0xC2;
	MOVLW       194
	MOVWF       TMR0H+0 
;CronometroDigitalPIC18F4550.c,29 :: 		TMR0L = 0xF7;
	MOVLW       247
	MOVWF       TMR0L+0 
;CronometroDigitalPIC18F4550.c,30 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;CronometroDigitalPIC18F4550.c,31 :: 		}
L_INTERRUPCAO_HIGH3:
;CronometroDigitalPIC18F4550.c,33 :: 		if(PIR1.TMR1IF == 1){
	BTFSS       PIR1+0, 0 
	GOTO        L_INTERRUPCAO_HIGH4
;CronometroDigitalPIC18F4550.c,34 :: 		PORTA.RA0 ^= 1;
	BTG         PORTA+0, 0 
;CronometroDigitalPIC18F4550.c,35 :: 		conta();
	CALL        _conta+0, 0
;CronometroDigitalPIC18F4550.c,36 :: 		TMR1H = 0x0B;
	MOVLW       11
	MOVWF       TMR1H+0 
;CronometroDigitalPIC18F4550.c,37 :: 		TMR1L = 0xDC;
	MOVLW       220
	MOVWF       TMR1L+0 
;CronometroDigitalPIC18F4550.c,38 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;CronometroDigitalPIC18F4550.c,39 :: 		}
L_INTERRUPCAO_HIGH4:
;CronometroDigitalPIC18F4550.c,40 :: 		}
L_end_INTERRUPCAO_HIGH:
L__INTERRUPCAO_HIGH10:
	RETFIE      1
; end of _INTERRUPCAO_HIGH

_main:

;CronometroDigitalPIC18F4550.c,43 :: 		void main(){
;CronometroDigitalPIC18F4550.c,44 :: 		ADCON1 |= 0X0F; //Define os pinos na porta B como entradas digitais (00001111).
	MOVLW       15
	IORWF       ADCON1+0, 1 
;CronometroDigitalPIC18F4550.c,46 :: 		INTCON2.RBPU = 0; //Habilita chave global de resistores de pull-up na porta B.
	BCF         INTCON2+0, 7 
;CronometroDigitalPIC18F4550.c,48 :: 		TRISD = 0;  //Define a porta D como saída.
	CLRF        TRISD+0 
;CronometroDigitalPIC18F4550.c,49 :: 		PORTD = 0;  //Define todos os valores da porta D com nível baixo (0).
	CLRF        PORTD+0 
;CronometroDigitalPIC18F4550.c,51 :: 		RCON.IPEN = 1; //Habilita os níveis de interrupção.
	BSF         RCON+0, 7 
;CronometroDigitalPIC18F4550.c,54 :: 		INTCON.GIEH = 1; //Habilita interrupção de alta prioridade se IPEN = 1.
	BSF         INTCON+0, 7 
;CronometroDigitalPIC18F4550.c,55 :: 		INTCON.INT0IE = 1; //Habilita interrupção externa na porta INT0.
	BSF         INTCON+0, 4 
;CronometroDigitalPIC18F4550.c,56 :: 		INTCON.INT0IF = 0; //Zera a flag de interrupção na porta INT0.
	BCF         INTCON+0, 1 
;CronometroDigitalPIC18F4550.c,57 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;CronometroDigitalPIC18F4550.c,58 :: 		INTCON.TMR0IF = 0;  //Zera a flag de interrupção de TMR0.
	BCF         INTCON+0, 2 
;CronometroDigitalPIC18F4550.c,61 :: 		INTCON2.INTEDG0 = 1; //Habilita a borda de subida na INT0.
	BSF         INTCON2+0, 6 
;CronometroDigitalPIC18F4550.c,64 :: 		INTCON3.INT1IP = 1; //Habilita a alta prioridade para a interrupção 1.
	BSF         INTCON3+0, 6 
;CronometroDigitalPIC18F4550.c,65 :: 		INTCON3.INT1IE = 1; //Habilita a interrupção externa na porta INT1.
	BSF         INTCON3+0, 3 
;CronometroDigitalPIC18F4550.c,66 :: 		INTCON3.INT1IF = 0; //Zera a flag de interrupção na porta INT1.
	BCF         INTCON3+0, 0 
;CronometroDigitalPIC18F4550.c,69 :: 		T0CON = 0b00000110;
	MOVLW       6
	MOVWF       T0CON+0 
;CronometroDigitalPIC18F4550.c,72 :: 		T1CON = 0b10110000;
	MOVLW       176
	MOVWF       T1CON+0 
;CronometroDigitalPIC18F4550.c,73 :: 		PIE1.TMR1IE = 1;
	BSF         PIE1+0, 0 
;CronometroDigitalPIC18F4550.c,76 :: 		TMR0H = 0xC2;
	MOVLW       194
	MOVWF       TMR0H+0 
;CronometroDigitalPIC18F4550.c,77 :: 		TMR0L = 0xF7;
	MOVLW       247
	MOVWF       TMR0L+0 
;CronometroDigitalPIC18F4550.c,79 :: 		TMR1H = 0x0B;
	MOVLW       11
	MOVWF       TMR1H+0 
;CronometroDigitalPIC18F4550.c,80 :: 		TMR1L = 0xDC;
	MOVLW       220
	MOVWF       TMR1L+0 
;CronometroDigitalPIC18F4550.c,81 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;CronometroDigitalPIC18F4550.c,82 :: 		IPR1.TMR1IP = 1;
	BSF         IPR1+0, 0 
;CronometroDigitalPIC18F4550.c,84 :: 		TRISB.RB0 = 1; //Põe o pino RB0/INT0 como entrada.
	BSF         TRISB+0, 0 
;CronometroDigitalPIC18F4550.c,85 :: 		TRISB.RB1 = 1; //Põe o pino RB1/INT1 como entrada.
	BSF         TRISB+0, 1 
;CronometroDigitalPIC18F4550.c,87 :: 		TRISA = 0;
	CLRF        TRISA+0 
;CronometroDigitalPIC18F4550.c,88 :: 		PORTA = 0x0F;
	MOVLW       15
	MOVWF       PORTA+0 
;CronometroDigitalPIC18F4550.c,90 :: 		contagem = 0;
	CLRF        _contagem+0 
	CLRF        _contagem+1 
;CronometroDigitalPIC18F4550.c,92 :: 		while(1); //Segura o processamento.
L_main5:
	GOTO        L_main5
;CronometroDigitalPIC18F4550.c,93 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
