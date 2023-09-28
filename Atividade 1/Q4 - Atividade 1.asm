org 00h ;Define a origem em 00h

JMP inicio ;Pula para o label 'inicio'

org 33h ;Define a origem em 33h

inicio:
	CLR A ;LIMPAR O REGISTRADOR ACC
	MOV R0, #10h ;MOVE DE FORMA IMEDIATA O HEXADECIMAL 10h PARA O REGISTRADOR R0.
	
bloco1:
	JZ bloco2 ;Pula para o 'bloco2' se ACC for 0
	JNZ bloco3 ;Pula para o 'bloco2' se ACC for diferente de 0.
	NOP ;Consome 1us de tempo.
bloco2:
	MOV ACC, R0 ;Move o valor de R0 para ACC.
	JMP bloco1
bloco3:
	DJNZ R0, bloco3 ;Decrementa o R0 e, se ele não for, salta-se ao bloco 3, em loop.
	JMP inicio ;Volta ao bloco de 'inicio'
end

;Esse começa limpando o acumulador e guardando um número no registrador 0. O 'bloco1' é responsável por direcionar o código para outros blocos, conforme o estado do acumulador. Se o acumulador for zero, então ele é carregado com o número no registrador R0, voltando para o 'bloco1'. Se o acumulador for diferente de 0, então ele é decrementado até zero e volta ao inicio, onde o processo inteiro é repetido.