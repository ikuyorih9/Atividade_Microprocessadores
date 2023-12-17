
_conta:

;CronometroDigitalPIC18F4550.c,7 :: 		void conta(){
;CronometroDigitalPIC18F4550.c,8 :: 		PORTD = bcd[contagem]; //Mostra o valor atual da contagem no display.
	MOVF        _contagem+0, 0 
	MOVWF       R0 
	MOVF        _contagem+1, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _contagem+1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVLW       _bcd+0
	ADDWF       R0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       hi_addr(_bcd+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       higher_addr(_bcd+0)
	ADDWFC      R2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, PORTD+0
;CronometroDigitalPIC18F4550.c,9 :: 		contagem++; //Aumenta a contagem.
	INFSNZ      _contagem+0, 1 
	INCF        _contagem+1, 1 
;CronometroDigitalPIC18F4550.c,10 :: 		if(contagem > 9) //Reinicia a contagem se ela passar de 9.
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
;CronometroDigitalPIC18F4550.c,11 :: 		contagem = 0;
	CLRF        _contagem+0 
	CLRF        _contagem+1 
L_conta0:
;CronometroDigitalPIC18F4550.c,12 :: 		}
L_end_conta:
	RETURN      0
; end of _conta

_INTERRUPCAO_HIGH:

;CronometroDigitalPIC18F4550.c,17 :: 		void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO{
;CronometroDigitalPIC18F4550.c,19 :: 		if(INTCON.INT0IF == 1){
	BTFSS       INTCON+0, 1 
	GOTO        L_INTERRUPCAO_HIGH1
;CronometroDigitalPIC18F4550.c,20 :: 		T0CON.TMR0ON = 1; //Inicia o timer TMR0 (1s).
	BSF         T0CON+0, 7 
;CronometroDigitalPIC18F4550.c,21 :: 		T1CON.TMR1ON = 0; //Para o timer TMR1 (0,25s).
	BCF         T1CON+0, 0 
;CronometroDigitalPIC18F4550.c,22 :: 		INTCON.INT0IF = 0; //Zera a flag de INT0.
	BCF         INTCON+0, 1 
;CronometroDigitalPIC18F4550.c,23 :: 		}
L_INTERRUPCAO_HIGH1:
;CronometroDigitalPIC18F4550.c,26 :: 		if(INTCON3.INT1IF == 1){
	BTFSS       INTCON3+0, 0 
	GOTO        L_INTERRUPCAO_HIGH2
;CronometroDigitalPIC18F4550.c,27 :: 		INTCON3.INT1IF = 0; //Para o timer TMR0 (1s).
	BCF         INTCON3+0, 0 
;CronometroDigitalPIC18F4550.c,28 :: 		T0CON.TMR0ON = 0; //Inicia o timer TMR1 (0,25s).
	BCF         T0CON+0, 7 
;CronometroDigitalPIC18F4550.c,29 :: 		T1CON.TMR1ON = 1; //Zera a flag de INT1.
	BSF         T1CON+0, 0 
;CronometroDigitalPIC18F4550.c,30 :: 		}
L_INTERRUPCAO_HIGH2:
;CronometroDigitalPIC18F4550.c,33 :: 		if(INTCON.TMR0IF == 1){
	BTFSS       INTCON+0, 2 
	GOTO        L_INTERRUPCAO_HIGH3
;CronometroDigitalPIC18F4550.c,34 :: 		PORTA.RA0 ^= 1; //Muda o estado lógico da porta A0.
	BTG         PORTA+0, 0 
;CronometroDigitalPIC18F4550.c,35 :: 		conta(); //Realiza a contagem.
	CALL        _conta+0, 0
;CronometroDigitalPIC18F4550.c,36 :: 		TMR0H = 0xC2; //Atualiza o primeiro byte de TMR0.
	MOVLW       194
	MOVWF       TMR0H+0 
;CronometroDigitalPIC18F4550.c,37 :: 		TMR0L = 0xF7; //Atualiza o último byte de TMR0.
	MOVLW       247
	MOVWF       TMR0L+0 
;CronometroDigitalPIC18F4550.c,38 :: 		INTCON.TMR0IF = 0; //Zera a flag de TMR0.
	BCF         INTCON+0, 2 
;CronometroDigitalPIC18F4550.c,39 :: 		}
L_INTERRUPCAO_HIGH3:
;CronometroDigitalPIC18F4550.c,42 :: 		if(PIR1.TMR1IF == 1){
	BTFSS       PIR1+0, 0 
	GOTO        L_INTERRUPCAO_HIGH4
;CronometroDigitalPIC18F4550.c,43 :: 		PORTA.RA0 ^= 1; //Muda o estado lógico da porta A0.
	BTG         PORTA+0, 0 
;CronometroDigitalPIC18F4550.c,44 :: 		conta(); //Realiza a contagem.
	CALL        _conta+0, 0
;CronometroDigitalPIC18F4550.c,45 :: 		TMR1H = 0x0B; //Atualiza o primeiro byte de TMR1.
	MOVLW       11
	MOVWF       TMR1H+0 
;CronometroDigitalPIC18F4550.c,46 :: 		TMR1L = 0xDC; //Atualiza o último byte de TMR0.
	MOVLW       220
	MOVWF       TMR1L+0 
;CronometroDigitalPIC18F4550.c,47 :: 		PIR1.TMR1IF = 0; //Zera a flag de TMR1.
	BCF         PIR1+0, 0 
;CronometroDigitalPIC18F4550.c,48 :: 		}
L_INTERRUPCAO_HIGH4:
;CronometroDigitalPIC18F4550.c,49 :: 		}
L_end_INTERRUPCAO_HIGH:
L__INTERRUPCAO_HIGH10:
	RETFIE      1
; end of _INTERRUPCAO_HIGH

_main:

;CronometroDigitalPIC18F4550.c,52 :: 		void main(){
;CronometroDigitalPIC18F4550.c,54 :: 		ADCON1 |= 0X0F; //Define os pinos na porta B como entradas digitais (00001111).
	MOVLW       15
	IORWF       ADCON1+0, 1 
;CronometroDigitalPIC18F4550.c,55 :: 		TRISA = 0x00; //Define a porta A como saída.
	CLRF        TRISA+0 
;CronometroDigitalPIC18F4550.c,56 :: 		PORTA = 0x00; //Define todos os valores da porta A com nível baixo (0).
	CLRF        PORTA+0 
;CronometroDigitalPIC18F4550.c,57 :: 		TRISD = 0x00;  //Define a porta D como saída.
	CLRF        TRISD+0 
;CronometroDigitalPIC18F4550.c,58 :: 		PORTD = 0x00;  //Define todos os valores da porta D com nível baixo (0).
	CLRF        PORTD+0 
;CronometroDigitalPIC18F4550.c,59 :: 		TRISB = 0x0F; //Define a porta B como entrada.
	MOVLW       15
	MOVWF       TRISB+0 
;CronometroDigitalPIC18F4550.c,60 :: 		INTCON2.RBPU = 0; //Habilita chave global de resistores de pull-up na porta B.
	BCF         INTCON2+0, 7 
;CronometroDigitalPIC18F4550.c,64 :: 		RCON.IPEN = 1; //Habilita os níveis de interrupção.
	BSF         RCON+0, 7 
;CronometroDigitalPIC18F4550.c,65 :: 		INTCON.GIEH = 1; //Habilita AS interrupções de alta prioridade se IPEN = 1.
	BSF         INTCON+0, 7 
;CronometroDigitalPIC18F4550.c,66 :: 		INTCON3.INT1IP = 1; //Habilita a alta prioridade para a interrupção 1.
	BSF         INTCON3+0, 6 
;CronometroDigitalPIC18F4550.c,67 :: 		IPR1.TMR1IP = 1; //Habilita a alta prioridade para a TMR1.
	BSF         IPR1+0, 0 
;CronometroDigitalPIC18F4550.c,71 :: 		INTCON.INT0IE = 1; //Habilita interrupção externa na porta INT0.
	BSF         INTCON+0, 4 
;CronometroDigitalPIC18F4550.c,72 :: 		INTCON3.INT1IE = 1; //Habilita a interrupção externa na porta INT1.
	BSF         INTCON3+0, 3 
;CronometroDigitalPIC18F4550.c,73 :: 		INTCON.TMR0IE = 1; //Habilita a interrupção do timer TMR0.
	BSF         INTCON+0, 5 
;CronometroDigitalPIC18F4550.c,74 :: 		PIE1.TMR1IE = 1; //Habilita a interrupção do timer TMR1.
	BSF         PIE1+0, 0 
;CronometroDigitalPIC18F4550.c,78 :: 		INTCON.INT0IF = 0; //Zera a flag de interrupção na porta INT0.
	BCF         INTCON+0, 1 
;CronometroDigitalPIC18F4550.c,79 :: 		INTCON3.INT1IF = 0; //Zera a flag de interrupção na porta INT1.
	BCF         INTCON3+0, 0 
;CronometroDigitalPIC18F4550.c,80 :: 		INTCON.TMR0IF = 0;  //Zera a flag de interrupção do timer TMR0.
	BCF         INTCON+0, 2 
;CronometroDigitalPIC18F4550.c,81 :: 		PIR1.TMR1IF = 0; //Zera a flag de interrupção do timer TMR1
	BCF         PIR1+0, 0 
;CronometroDigitalPIC18F4550.c,84 :: 		TMR0H = 0xC2; //Primeiro byte do TMR0.
	MOVLW       194
	MOVWF       TMR0H+0 
;CronometroDigitalPIC18F4550.c,85 :: 		TMR0L = 0xF7; //Último byte do TMR0.
	MOVLW       247
	MOVWF       TMR0L+0 
;CronometroDigitalPIC18F4550.c,86 :: 		TMR1H = 0x0B; //Primeiro byte do TMR1.
	MOVLW       11
	MOVWF       TMR1H+0 
;CronometroDigitalPIC18F4550.c,87 :: 		TMR1L = 0xDC; //Último byte do TMR1.
	MOVLW       220
	MOVWF       TMR1L+0 
;CronometroDigitalPIC18F4550.c,90 :: 		INTCON2.INTEDG0 = 1; //Habilita a borda de subida na INT0.
	BSF         INTCON2+0, 6 
;CronometroDigitalPIC18F4550.c,91 :: 		T0CON = 0b00000110; //Configura o registrador T0CON, referente ao TMR0.
	MOVLW       6
	MOVWF       T0CON+0 
;CronometroDigitalPIC18F4550.c,92 :: 		T1CON = 0b10110000; //Configura o registrador T1CON, referente ao TMR1.
	MOVLW       176
	MOVWF       T1CON+0 
;CronometroDigitalPIC18F4550.c,93 :: 		contagem = 0; //Começa a contagem em 0.
	CLRF        _contagem+0 
	CLRF        _contagem+1 
;CronometroDigitalPIC18F4550.c,95 :: 		while(1); //Segura o processamento.
L_main5:
	GOTO        L_main5
;CronometroDigitalPIC18F4550.c,96 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
