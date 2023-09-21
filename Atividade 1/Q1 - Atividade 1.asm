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

;a) Qual foi o tempo gasto em cada linha de instrução e o tempo total em us?
;	R = As instruções gastam 2us (considerando SETB e CLR como uma linha só). O tempo total foi de 23us.

;b) Quantos ciclos de máquina esse programa contem?
;	R = Como o cristal oscilador do 8051 é de 12MHz e 1 ciclo de máquina leva 12 períodos de clock, então 1 ciclo de máquina leva 1us. Como o código tem 23us de tempo total, conclui-se que o programa gasta 23 ciclos de máquina.

;c)
;	R=

;d) Qual valor apareceu no acumulador após ter movido R1 de forma indireta para ele?
;	R = O valor que apareceu no acumulador é o valor salvo na memória na posição apontada por R1. No caso FF.

;e) 
;	R = O DPTR é uma junção de dois registradores, o DPH e o DPL, cada um com 2 digitos. O valor 9A foi para o DPH e o 5B para o DPL. Assim, o maior valor possível para o DPTR é FFFFh. 