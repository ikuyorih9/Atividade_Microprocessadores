org 0000h

inicio:
	MOV ACC, #2h ;Transfere 2 em hexadecimal para o registrador ACC.
	MOV ACC, #0	

	;Muda o banco para 00b (0).
	CLR RS0 
	CLR RS1

	MOV R0, #10h ;Move de forma direta 10 em hexadecimal para o resgistrador R0.
	MOV B, #9h ;Move de forma direta o 9 em hexadecimal para o registrador B	
	MOV 0Fh, P1 ;Move o valor da porta P1 para a posiÃ§Ã£o 0F da memÃ³ria.
	
	;Muda o banco para 01b (1).
	SETB RS0
	CLR RS1
	
	MOV R0, 0Fh ;Move o valor na posiÃ§Ã£o 0F para o registrador 0.
	MOV 7Fh, R0 ; Move o do registrador R0 para o endereÃ§o 7F.
	MOV R1, #7Fh ;Aponta o registrador R1 para a posiÃ§Ã£o 7F
	MOV ACC, @R1 ;ObtÃ©m o valor da posiÃ§Ã£o dado pelo valor de R1 para o acumulador.
	MOV DPTR, #9A5Bh ;Move 9A5B para o DPH p
	NOP

end

;a) Qual foi o tempo gasto em cada linha de instruÃ§Ã£o e o tempo total em us?
;	R = As instruções gastam 2us (considerando SETB e CLR como uma linha só). O tempo total foi de 23us.

;b) Quantos ciclos de mÃ¡quina esse programa contem?
;	R = Como o cristal oscilador do 8051 é de 12MHz e 1 ciclo de máquina leva 12 períodos de clock, então 1 ciclo de máquina leva 1us. Como o código tem 23us de tempo total, conclui-se que o programa gasta 23 ciclos de máquina.

;c)O que aconteceu ao mover uma porta inteira de 8 registradores(como: “MOV A, P1”, no exemplo) para um destino e porque seu valor é FF ? (consulte a página 7 do datasheet AT89S51 Atmel que versa sobre a inicialização de registradores - lembrando que o MCS-51 possui 4 portas: P1, P2, P3, P4).
;	R = Ao mover uma porta inteira de 8 bits o valor de P1 é copiado para o registrador selecionado. Quando P1 está em FFh, os pinos estão aptos para serem usados como entradas.

;d)  Qual valor apareceu no acumulador após ter movido R1 de forma indireta para ele?
;	R = O valor que apareceu em ACC foi o valor da memória, no endereço apontado por R1. Ou seja, R1 guardava uma posição de memória, que foi acessado e seu valor copiado para ACC.

;e Por que foi possível mover um valor de 4 dígitos para DPTR? Em quais registradores especiais do simulador foi possível verificar mudanças quando a operação foi realizada? Qual o maior valor que pode ser movido para DPTR em hexadecimal? 
;	R = O DPTR é uma junção de dois registradores, o DPH e o DPL, cada um com 2 digitos. O valor 9A foi para o DPH e o 5B para o DPL. Assim, o maior valor possível para o DPTR é FFFFh. 
