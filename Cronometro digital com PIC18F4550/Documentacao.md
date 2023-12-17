# Cronometro Digital com PIC18F4550.

* Guilherme Chiarotto de Moraes ();
* Hugo Hiroyuki Nakamura (12732037);

---

## 1 Conceitos envolvidos e resultados obtidos.

O projeto do cronometro digital com o PIC18F4550 tem o funcionamento centrado na utilização de interrupções, o uso dos registradores internos e de componentes agregados, como dois botões e um display de 7 segmentos.

A interrupção acontece de duas maneiras: através de botões ou de timers.

### 1.1 Interrupção por botões.

A interrupção por botões utiliza as interrupções **INT0** e **INT1**, configuradas pelos registradores *INTCON*, *INTCON2* e *INTCON3* da seguinte forma:

#### 1.1.1 Registrador INTCON.

O registrador INTCON é inicializado com o número **0xB0**.

<p align = center>

| GIE/GIEH 	| PEIE/GIEL 	| TMR0IE 	| INT0IE 	| RBIE 	| TMR0IF 	| INT0IF 	| RBIF 	|
|:--------:	|:---------:	|:------:	|:------:	|:----:	|:------:	|:------:	|:----:	|
|     1    	|     0     	|    1   	|    1   	|   0  	|    0   	|    0   	|   0  	|

</p>
<p align=center> 
    <b>Tabela 1: registrador INTCON com os valores usados no projeto.</b>
</p>

* **GIE/GIEH (1)**: quando IPEN = 1, GIEH habilita interrupção de alta prioridade;
* **PEIE/GIEL (0)**: quando IPEN = 1, GIEL desabilita a interrupção de baixa prioridade;
* **TMR0IE (1)**: habilita interrupção ao overflow de TMR0;
* **INT0IE (1)**: habiita interrupção externa;
* **RBIE (0)**: desabilita a interrupção por mudança na porta B;
* **TMR0IF (0)**: zera a flag de overflow na interrupção na porta TMR0;
* **INT0IF (0)**: zera a flag de interrupção externa na porta INT0;
* **RBIF (0)**: zera a flag de interrupção por mudança na porta B.

#### 1.1.2 Registrador INTCON2.

O registrador INTCON2 é inicializado com o número **0x64**.

<p align = center>

| !RBU 	| INTEDG0 	| INTEDG1 	| INTEDG2 	| - 	| TMR0IP 	| - 	| RBIP 	|
|:----:	|:-------:	|:-------:	|:-------:	|:-:	|:------:	|:-:	|:----:	|
|   0  	|    1    	|    1    	|    0    	| 0 	|    1   	| 0 	|   0  	|

</p>
<p align=center> 
    <b>Tabela 2: registrador INTCON2 com os valores usados no projeto.</b>
</p>

* **!RBPU (0)**: habilita os resistores de pull-up da porta B;
* **INTEDG0 (1)**: habilita a borda de subida na interrupção 0;
* **INTEDG1 (1)**: habilita a borda de subida na interrupção 1;
* **INTEDG2 (0)**: desabilita a borda de subida na interrupção 2;
* **TMR0IP (1)**: Habilita alta prioridade no overflow de TMR0;
* **RBIP (0)**: Habilita a alta prioridade na interrupção por mudança na porta B.

#### 1.1.3 Registrador INTCON3.

O registrador INTCON3 é inicializado com o número **0x49**.

<p align=center> 

| INT2IP 	| INT1IP 	| - 	| INT2IE 	| INT1IE 	| - 	| INT2IF 	| INT1IF 	|
|:------:	|:------:	|:-:	|:------:	|:------:	|:-:	|:------:	|:------:	|
|    0   	|    1   	| 0 	|    0   	|    1   	| 0 	|    0   	|    1   	|
</p>
<p align=center> 
    <b>Tabela 3: registrador INTCON3 com os valores usados no projeto.</b>
</p>

* **INT2IP (0)**: desabilita a alta prioridade da interrupção 2;
* **INT1IP (1)**: habilita a alta prioridade da interrupção 1;
* **INT2IE (0)**: desabilita a interrupção externa INT2;
* **INT1IE (1)**: habilita a interrupção externa INT1;
* **INT2IF (0)**: zera a aflag de interrupção externa na porta INT2;
* **INT1IF (0)**: zera flag de interrupção externa na porta INT21.

### 1.2 Interrupção por timer.

A interrupção por timers utiliza as interrupções **TMR0** e **TMR1**, configuradas pelos registradores T0CON e T1CON da seguinte forma:

#### 1.2.1 T0CON.

| TMR0ON 	| T0BIT 	| T0CS 	| T0SE 	| PSA 	| T0PS2 	| T0PS1 	| T0PS0 	|
|:------:	|:-----:	|:----:	|:----:	|:---:	|:-----:	|:-----:	|:-----:	|
|    0   	|   0   	|   0  	|   0  	|  0  	|   1   	|   1   	|   0   	|

* **TMR0ON (0)**: para o TMR0;
* **T0BIT (0)**: configura um timer de 16 bits;
* **T0CS (0)**: utiliza o clock interno como fonte de clock;
* **T0SE (0)**: seleciona borda de subida (0);
* **PSA (0)**: habilita o pre-scaler;
* **T0PS (110)**: 3 bits que selecionam 8 pre-scalers diferentes. No nosso caso, utilizaremos 110b, para um pre-scaler 1:128.

#### 1.2.2 T1CON.

| RD16 	| T1RUN 	| T1CKPS1 	| T1CKPS0 	| T1OSCEN 	| !T1SYNC 	| TMR1CS 	| TMR1ON 	|
|:----:	|:-----:	|:-------:	|:-------:	|:-------:	|:-------:	|:------:	|:------:	|
|   1  	|   0   	|    1    	|    1    	|    0    	|    0    	|    0   	|    0   	|

* **RD16 (1)**: habilita escrita/leitura do timer 1 numa operação de 16 bits;
* **T0BIT (0)**: o dispositivo de clock é derivador de outra fonte (0);
* **T1CKPS (11)**: 2 bits que selecionam o prescaler. Para o nosso caso, utilizaremos 11, para um prescaler de 1:8;
* **T1OSCEN (0)**: desabilita o oscilador do timer 1;
* **!T1SYNC (0)**: bit ignorado;
* **TMR1CS (0)**: desabilita o uso de um clock externo;
* **TMR1ON (0)**: para o TMR1.

#### 1.2.3 Outros registradores.

Para o TMR1 é preciso, ainda, utilizar bits de outros registradores para configurá-lo:

* **PIE1.TMR1IE (1)**: habilita a interrupção de alta prioridade do TMR1;
* **PIR1.TMR1IF (0)**: zera a flag de interrupção do TMR1.

#### 1.2.4. Overflow dos registradores TMR0 e TMR1.

## Circuito no Simulide.

## Código comentado.