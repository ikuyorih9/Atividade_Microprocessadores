# Projeto de um cronômetro digital usando Assembly e 8051.

Alunos:
* Guilherme Chiarotto de Moraes - 12745229;
* Hugo Hiroyuki Nakamura - 12732037.
---

## 1. Principais blocos do projeto.

### 1.1. Rotinas de espera.

O projeto é dividido em dois funcionamentos: a contagem de tempo a cada 250ms e a contagem de tempo a cada 1s. Para isso, uma rotina de espera de 10ms foi criada, servindo de base para rotinas de tempos maiores.

```
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

```

Dessa forma, é possível criar rotinas de espera de 250ms e de 1s executando a rotina de 10ms 25 e 100 vezes, respectivamente.

```
;Rotina de delay de 0,25 segundo.

Espera250ms:
	PUSH 00h
	MOV R0, #25 ;Carrega o registrador R0 com o número 25.
	Espera250ms_ciclo10ms:
		ACALL Espera10ms ;Chama a rotina de esperar 10ms.
		DJNZ R0, Espera250ms_ciclo10ms ;Decrementa o valor de R0 e volta ao início se não for 0.
	POP 00h
	RET
```

```
;Rotina de delay de 1 segundo.

Espera1s:
	PUSH 00h ;Salva o valor de R0 na pilha.
	MOV R0, #100 ;Carrega o registrador R0 com o número 100.
	Espera1s_ciclo10ms:
		ACALL Espera10ms ;Chama a rotina de esperar 10ms, sem executar uma condição.
		DJNZ R0, Espera1s_ciclo10ms ;Decrementa o valor do registrador R1 e volta ao início do ciclo se não tiver valor 0.
	POP 00h ;Recupera o valor de R0 da pilha.
	RET
```

### 1.2. Avaliando o funcionamento das chaves.

Quando a chave 0 é pressionada, a contagem tem um intervalo de 250ms e quando a chave 1 é pressionada, a contagem tem um intervalo de 1s. Mas para a contagem funcionar, alguma chave deve estar pressionada. Para isso, há a rotina de receber uma entrada válida. Sabendo que a porta 2 (P2) é o barramento das chaves do 8051, utiliza-se uma máscara binária para selecionar apenas os bits referentes às chaves 0 e 1. Se ambas as chaves estiverem desligadas, isto é, se a porta apresentar 00000011b, o código volta ao início da rotina. Caso contrário, o código continua.

```
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
```

## Varredura do display de 7 segmentos no 8051.

Um número no display de 7 segmentos equivale a um byte, contendo as informações dos 7 segmentos mais o ponto. Assim, o número 1 seria representado por 10011111b ou 9Fh. Fazendo o mesmo para todos os segmentos, tem-se a tabela.

```
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
``` 

A tabela, então, é passada para o registrador DPTR, de 16 bits. O registrador ACC é o iterador da tabela, e, portanto, '@ACC+DPTR' aponta para a posição onde os segmentos estão selecionados. Esse valor é salvo em ACC e depois passado para a porta 1 (P1), que é o barramento dos segmentos do display.

```
MOV R0, #10 ;R0 como um iterador decrescente.
MOV R1, #00 ;R1 com o primeiro valor da contagem.

MOV DPTR, #segmentos ;Carrega um registrador de 16 bits com os valores de cada 7seg.
MOV ACC, R1 ;Acumulador recebe a posição do início da contagem na tabela de segmentos
MOVC ACC, @ACC+DPTR ;Acumulador recebe o valor do byte correspondente ao segmento apontado.
MOV P1, A ;Acumulador passa esse valor para a porta P1, onde está o display 7seg.
INC R1 ;A contagem é incrementada.
``` 

## Diagrama esquemático do 8051.

<p align="center">
    <img width = 600 src="Images/Figura - diagrama logico 8051.png">
</p>

## Código completo comentado.

```
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

```