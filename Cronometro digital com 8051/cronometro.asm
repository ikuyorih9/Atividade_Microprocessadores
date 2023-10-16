SW_250ms EQU P2.0 ;Dá nome 'SW_250ms' ao SW0.
SW_1s EQU P2.1 ;Dá nome 'SW_1s' ao SW1.

org 00h
jmp main

main:	
	ACALL configuracoes ;Configurações iniciais do projeto.	
	
	MOV DPTR, #segmentos ;Carrega um registrador de 16 bits com os valores de cada 7seg.
	
	Contagem:
		MOV R0, #10 ;R0 como um iterador decrescente.
		MOV R1, #00 ;R1 com o primeiro valor da contagem.	

		LoopConta:
			ACALL RecebeEntradaValida ;Verifica se alguma chave está pressionada.
			MOV A, R1 ;Acumulador recebe a posição do início da contagem na tabela de segmentos
			MOVC A, @A+DPTR ;Acumulador recebe o valor do byte correspondente ao segmento apontado.
			MOV P1, A ;Acumulador passa esse valor para a porta P1, onde está o display 7seg.
			INC R1 ;A contagem é incrementada.
			JNB SW_250ms, Rapidinho ;Se a chave de 250ms está pressionada, vai ao bloco 'rapidinho'
			JNB SW_1s, Lentinho ;Se a chave de 1s está pressionada, vai ao bloco 'lentinho'
			
			;Bloco que espera 250ms.
			Rapidinho:
				ACALL Espera250ms
				JMP Decrementa	
			;Bloco que espera 1s.
			Lentinho:
				ACALL Espera1s
				JMP Decrementa
			Decrementa:
				DJNZ R0, loopConta ;Se R0 não chegou a 0, continua o loop.
	jmp Contagem ;Se R0 chegou a 0, volta a contagem ao início.

;Rotina de delay de 10ms.
Espera10ms:
	PUSH 00h ;Salva o valor de R0 na pilha.
	PUSH 01h ;Salva o valor de R1 na pilha.

	MOV R0, #25 ;Carrega o registrador R0 com o número 25.

	InicioCiclo200: ;Subrotina de contagem de 200 ciclos de máquina.
		MOV R1, #200 ;Carrega o registrador R1 com o número 200.
		DJNZ R1, $ ;Decrementa o valor de R1 e mantém nessa linha até o valor de R1 ser 0.
	DJNZ R0, inicioCiclo200 ;Decrementa o valor de R0 e volta ao início do ciclo se não tiver valor 0.

	POP 01h ;Recupera o valor de R1 na pilha.
	POP 00h ;Recupera o valor de R0 na pilha.
	RET
		

;Rotina de delay de 1 segundo.
Espera1s:
	PUSH 00h ;Salva o valor de R0 na pilha.
	MOV R0, #100 ;Carrega o registrador R0 com o número 100.
	Espera1s_ciclo10ms:
		ACALL Espera10ms ;Chama a rotina de esperar 10ms, sem executar uma condição.
		DJNZ R0, Espera1s_ciclo10ms ;Decrementa o valor do registrador R1 e volta ao início do ciclo se não tiver valor 0.
	POP 00h ;Recupera o valor de R0 da pilha.
	RET

;Rotina de delay de 0,25 segundo.
Espera250ms:
	PUSH 00h
	MOV R0, #25 ;Carrega o registrador R0 com o número 100.
	Espera250ms_ciclo10ms:
		ACALL Espera10ms ;Chama a rotina de esperar 10ms.
		DJNZ R0, Espera250ms_ciclo10ms ;Decrementa o valor de R0 e volta ao início se não for 0.
	POP 00h
	RET

;Espera que pelo menos uma das chaves esteja acionada.
RecebeEntradaValida:
	PUSH 00h ;Salva o valor do registrador R0 na pilha.
	LePorta:
		MOV R0, P2 ;Move o barramento das chaves para o registrador R0.
		ANL 00h,#00000011b ;Seleciona apenas os bits das chaves 0 e 1.
		CJNE R0, #00000011b, Continue ;Se ambas as chaves não estão desselecionadas, continua ao fim da rotina.
		JMP LePorta ;Se ambas as chaves estão selecionadas, retorna ao início da rotina.
	Continue:
		POP 00h; Recupera o valor do registrador R0 da pilha.
		RET

Configuracoes:
	;Seleciona o banco de registradores 0.
	CLR RS1
	CLR RS0

	;Seleciona o display 0
	CLR P3.3
	CLR P3.4

	RET

;Tabela de segmentos do 0 ao 9.
segmentos:
	db 0C0h
	db 0F9h
	db 0A4h
	db 0B0h
	db 99h
	db 92h
	db 82h
	db 0F8h
	db 80h
	db 90h

end





	
