org 0000h

inicio:
	MOV ACC, #2h ;Transfere 2 em hexadecimal para o registrador ACC.
	MOV ACC, #0	

	;Muda o banco para 00b (0).
	CLR RS0 
	CLR RS1

	MOV R0, #10h ;Move de forma direta 10 em hexadecimal para o resgistrador R0.
	MOV B, #9h ;Move de forma direta o 9 em hexadecimal para o registrador B	
	MOV 0Fh, P1 ;Move o valor da porta P1 para a posição 0F da memória.
	
	;Muda o banco para 01b (1).
	SETB RS0
	CLR RS1
	
	MOV R0, 0Fh ;Move o valor na posição 0F para o registrador 0.
	MOV 7Fh, R0 ; Move o do registrador R0 para o endereço 7F.
	MOV R1, #7Fh ;Aponta o registrador R1 para a posição 7F
	MOV ACC, @R1 ;Obtém o valor da posição dado pelo valor de R1 para o acumulador.
	MOV DPTR, #9A5Bh ;Move 9A5B para o DPH p
	NOP

end