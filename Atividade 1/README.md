# Atividade prática de uso de set de instruções e manipulação de dados em registradores e endereços de memória em microcontroladores.

Alunos:
* Arthur Breno dos Reis Paula - 12547382;
* Guilherme Chiarotto de Moraes - 12745229;
* Hugo Hiroyuki Nakamura - 12732037.

---

## 1) Manipulação de dados em registradores e endereços de memória por meio de instruções de transferência de dados:

```
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
```

**a) Qual foi o tempo gasto em cada linha de instrução e o tempo total em us?**

As instruções gastam 2us (considerando SETB e CLR como uma linha só). O tempo total foi de 23us.

**b) Quantos ciclos de máquina esse programa contem?**

Como o cristal oscilador do 8051 é de 12MHz e 1 ciclo de máquina leva 12 períodos de clock, então 1 ciclo de máquina leva 1us. Como o código tem 23us de tempo total, conclui-se que o programa gasta 23 ciclos de máquina.

**c) O que aconteceu ao mover uma porta inteira de 8 registradores(como: 'MOV A, P1', no exemplo) para um destino e porque seu valor é FF ? (consulte a página 7 do datasheet AT89S51 Atmel que versa sobre a inicialização de registradores - lembrando que o MCS-51 possui 4 portas: P1, P2, P3, P4).**

Ao mover uma porta inteira de 8 bits o valor de P1 é copiado para o registrador selecionado. Quando P1 está em FFh, os pinos estão aptos para serem usados como entradas.

**d) Qual valor apareceu no acumulador após ter movido R1 de forma indireta para ele?**

O valor que apareceu em ACC foi o valor da memória, no endereço apontado por R1. Ou seja, R1 guardava uma posição de memória, que foi acessado e seu valor copiado para ACC.

**e) Por que foi possível mover um valor de 4 dígitos para DPTR? Em quais registradores especiais do simulador foi poss�vel verificar mudanças quando a operação foi realizada? Qual o maior valor que pode ser movido para DPTR em hexadecimal?**

O DPTR é uma junção de dois registradores, o DPH e o DPL, cada um com 2 digitos. O valor 9A foi para o DPH e o 5B para o DPL. Assim, o maior valor possível para o DPTR é FFFFh. 

## 2) Manipulação de dados em registradores e endereços de memória por meio de instruções aritméticas: 

```
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
```
**1) Em um novo programa, mover de forma imediata o valor 4 para o ACC; na linha seguinte mover de forma imediata o valor 3 para o ACC. Execute as duas linhas clicando em “Assm”, observando PSW. Porque ao mover o valor 4 para ACC, o bit menos significativo de PSW resulta em 1; e ao mover o valor 3 esse bit resulta em 0?(OBS. Não é necessário salvar esse novo programa, somente execute a operação para responder a questão).**

Isso ocorre pelo fato de que se a quantidade de bits 1 do meu valor for ímpar, o PSW indica o bit menos significativo como 1, e se o número de bits 1 for par o PSW indica como 0. No exemplo dado, o valor 4 (0100) indica 1 como o esperado e, o valor 3 (0011), indica 0.

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

	ORL A,B ;OR entre A e B
	XRL A,B ;XOR entre A e B
	SWAP A ;Swap de A

	JMP inicio ;volta para o inicio
	
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
