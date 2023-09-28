## 2) Manipulação de dados em registradores e endereços de memória por meio de instruções aritméticas: 

```
org 00h

inicio:
MOV ACC,#02 ;Transfere o valor 2 em decimal para o registrador ACC
MOV B,#03 ;Transfere o valor 3 em decimal para o registrador B
MOV 022h,#07 ;Transfere o valor 7 em decimal para o endereço 22 da memória
ADD A,022h ;Soma o conteúdo do endereço de memória 22 com o ACC
DEC A,#03 ;Decrementa 3 unidades do registrador ACC
INC B ;Incrementa 1 unidade no registrador B
SUBB B,A ;Subtrai o conteúdo de A por B
MUL AB ;Multiplica A por B
INC B,#02 ;Incrementa 2 unidades no registrador B
DIV B,A ;Divide A por B
;NÃO SEI MAIS :(((
STO
```

## 3) Manipulação de dados em registradores e endereços de memória por meio de instruções lógicas e booleanas:

```
org 0000h ;origem no endereço 00h

inicio:
	MOV ACC,#00010001b ;Transfere 00010001 em binario para o registrador ACC.
	MOV B,#00001001b ;Transfere 00001001 em binario para o registrador B

	ANL A,B ;Realiza AND entre A e B

  	;Rotate right (rotacao a direita) duas vezes:
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
```

## 4) Manipulação de dados em registradores e endereços de memória por meio de instruções de desvio incondicional e condicional:

```
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
```

Esse começa limpando o acumulador e guardando um número no registrador 0. O 'bloco1' é responsável por direcionar o código para outros blocos, conforme o estado do acumulador. Se o acumulador for zero, então ele é carregado com o número no registrador R0, voltando para o 'bloco1'. Se o acumulador for diferente de 0, então ele é decrementado até zero e volta ao inicio, onde o processo inteiro é repetido.
