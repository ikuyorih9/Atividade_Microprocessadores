
_main:

;ConversorAD.c,47 :: 		void main(){
;ConversorAD.c,49 :: 		unsigned int Valor_ADC = 0;  // var. para leitura
;ConversorAD.c,53 :: 		TRISA.RA5 = 1;
	BSF         TRISA+0, 5 
;ConversorAD.c,54 :: 		ADCON1 = 0B00000000; //Configura todos os canais como ADC no PIC18F4450
	CLRF        ADCON1+0 
;ConversorAD.c,58 :: 		Lcd_Init();                 // Inicializa a lib. Lcd
	CALL        _Lcd_Init+0, 0
;ConversorAD.c,59 :: 		Lcd_Cmd(_LCD_CLEAR);       // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;ConversorAD.c,60 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);  // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;ConversorAD.c,61 :: 		Lcd_Out(1,1,"ADC0:");   //Escreve na Linha x Coluna do LCD o texto(valor do ADC)
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_ConversorAD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_ConversorAD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;ConversorAD.c,63 :: 		ADC_Init();  // uso da fun��o da biblioteca ADC do pr�prio compilador
	CALL        _ADC_Init+0, 0
;ConversorAD.c,66 :: 		while(TRUE)
L_main0:
;ConversorAD.c,68 :: 		Valor_ADC = ADC_Read(4); // fun��o da biblioteca ADC do compilador para
	MOVLW       4
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;ConversorAD.c,76 :: 		Valor_ADC = Valor_ADC * (1234/1023.); // formata o valor de entrada (neste caso o valor de exemplo '1234')
	CALL        _word2double+0, 0
	MOVLW       154
	MOVWF       R4 
	MOVLW       102
	MOVWF       R5 
	MOVLW       26
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
;ConversorAD.c,80 :: 		Tensao[0] = (Valor_ADC/1000) + '0';// div. de 2 n� inteiros - em programa��o
	MOVLW       48
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       main_Tensao_L0+0 
;ConversorAD.c,84 :: 		Tensao[1] = (Valor_ADC/100)%10 + '0'; // div. de n� inteiros => 1234/100 = 12
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+1 
;ConversorAD.c,88 :: 		Tensao[2] = '.';    //3� valor corresponde ao ponto - ex. 12.34
	MOVLW       46
	MOVWF       main_Tensao_L0+2 
;ConversorAD.c,90 :: 		Tensao[3] = (Valor_ADC/10)%10 + '0'; // 4� valor � a 1�casa decimal, portanto:
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+3 
;ConversorAD.c,92 :: 		Tensao[4] = (Valor_ADC/1)%10 + '0';  // formata o valor da 2� casa decimal
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+4 
;ConversorAD.c,94 :: 		Tensao[5] = 0; //terminador NULL (ultima posi��o da matriz - zero indica o
	CLRF        main_Tensao_L0+5 
;ConversorAD.c,104 :: 		Lcd_Out(1,6,Tensao); // Mostra os valores no display
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_Tensao_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_Tensao_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;ConversorAD.c,105 :: 		Delay_ms(20);   // atualizar display
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	NOP
	NOP
;ConversorAD.c,106 :: 		}
	GOTO        L_main0
;ConversorAD.c,107 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
