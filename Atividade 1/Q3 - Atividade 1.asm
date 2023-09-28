org 0000h ;origem no endereço 00h

inicio:
	MOV ACC,#00010001b ;Transfere 00010001 em binario para o registrador ACC.
	MOV B,#00001001b ;Transfere 00001001 em binario para o registrador B

	ANL A,B ;Realiza AND entre A e B

  ;Rotate right (rotacao a direita) duas vezes
	RR A 
	RR A

	CPL A ;Complemento de A

  ;Rotate Left (rotacao a esquerda) duas vezes:
	RL A 
	RL A

	ORL A,B :OR entre A e B
	XRL A,B :XOR entre A e B
	SWAP A :Swap de A

	JMP inicio :volta para o inicio
	
	end ;encerra o programa
