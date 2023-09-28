org 00h

inicio:
org 00h

inicio:
	MOV ACC,#02 ;Transfere o valor 2 em decimal para o registrador ACC
	MOV B,#03 ;Transfere o valor 3 em decimal para o registrador B
	MOV 022h,#07 ;Transfere o valor 7 em decimal para o endereço 22 da memória
	ADD A,022h ;Soma o conteúdo do endereço de memória 22 com o ACC
	;Decrementa 3 unidades em A
	DEC A
	DEC A
	DEC A
	INC B ;Incrementa 1 unidade no registrador B
	SUBB A,B ;Subtrai o conteúdo de A por B
	MUL AB ;Multiplica A por B
	;Incrementa 2 unidades em B
	INC B
	INC B
	DIV AB ;Divide A por B
	
	;Armazenana os valor de A e B em dois endereços de memória
	MOV 04h, A
	MOV 03h, B
	
	JMP inicio ;Vai para o início
end ;Fim do programa
