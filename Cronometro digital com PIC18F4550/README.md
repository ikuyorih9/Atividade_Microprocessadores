# Cronômetro Digital com PIC18F4550

## Configurações iniciais.

### ADCON1.

| UNUSED 	| UNUSED 	| VCFG1 	| VCFG0 	| PCFG3 	| PCFG2 	| PCFG1 	| PCFG0 	|
|:------:	|:------:	|:-----:	|:-----:	|:-----:	|:-----:	|:-----:	|:-----:	|
|    0   	|    0   	|   0   	|   0   	|   1   	|   1   	|   1   	|   1   	|

* **VCFG**: bits de configuração de tensão de referência. O bit 0 define VREF+, enquanto o bit 1 define o VREF-. Escolher 00 define VREF+ = Vdd e VREF- = Vss.
* **PCFG**: bits de configuração AD. Os quatro bits são capazes de identificar 16 estados diferentes. Os mais importantes são;
    * **0000**: seleciona todas as portas B como analógicas;
    * **1000**: seleciona metade das portas como analógicas e metade como digitais;
    * **1111**: seleciona todas as portas B como digitais.

### INTCON e INTCON2.

Para o registrador **INTCON**.

| GIE/GIEH 	| PEIE/GIEL 	| TMR0IE 	| INT0IE 	| RBIE 	| TMR0IF 	| INT0IF 	| RBIF 	|
|:--------:	|:---------:	|:------:	|:------:	|:----:	|:------:	|:------:	|:----:	|
|     1    	|     0     	|    1   	|    1   	|   0  	|    0   	|    0   	|   0  	|

* **GIE/GIEH**: quando IPEN = 1, GIEH habilita interrupção de alta prioridade;
* **PEIE/GIEL**: quando IPEN = 1, GIEL habilita interrupção de baixa prioridade;
* **TMR0IE**: habilita interrupção ao overflow de TMR0;
* **INT0IE**: habiita interrupção externa;
* **RBIE**: habilita a interrupção por mudança na porta B;
* **TMR0IF**: flag de overflow na interrupção na porta TMR0;
* **INT0IF**: flag de interrupção externa na porta INT0;
* **RBIF**: flag de interrupção por mudança na porta B.

Para o registrador **INTCON2**.

| !RBU 	| INTEDG0 	| INTEDG1 	| INTEDG2 	| - 	| TMR0IP 	| - 	| RBIP 	|
|:----:	|:-------:	|:-------:	|:-------:	|:-:	|:------:	|:-:	|:----:	|
|   0  	|    1    	|    1    	|    X    	| 0 	|    1   	| 0 	|   X  	|

* **!RBPU**: Habilita os resistores de pull-up da porta B;
* **INTEDG0**: Habilita a borda de subida na interrupção 0;
* **INTEDG1**: Habilita a borda de subida na interrupção 1;
* **INTEDG2**: Habilita a borda de subida na interrupção 2;
* **TMR0IP**: Habilita alta prioridade no overflow de TMR0;
* **RBIP**: Habilita a alta prioridade na interrupção por mudança na porta B.

Para nossa aplicação, os valores INTEDG2 e RBIP não importam.

Para o registrador **INTCON3**.

| INT2IP 	| INT1IP 	| - 	| INT2IE 	| INT1IE 	| - 	| INT2IF 	| INT1IF 	|
|:------:	|:------:	|:-:	|:------:	|:------:	|:-:	|:------:	|:------:	|
|    X   	|    1   	| - 	|    0   	|    1   	| - 	|    X   	|    1   	|

* **INT2IP**: habilita a alta prioridade da interrupção 2;
* **INT1IP**: habilita a alta prioridade da interrupção 1;
* **INT2IE**: habilita a interrupção externa INT2;
* **INT1IE**: habilita a interrupção externa INT1;
* **INT2IF**: flag de interrupção externa na porta INT2;
* **INT1IF**: flag de interrupção externa na porta INT21

### **T0CON.**

| TMR0ON 	| T0BIT 	| T0CS 	| T0SE 	| PSA 	| T0PS2 	| T0PS1 	| T0PS0 	|
|:------:	|:-----:	|:----:	|:----:	|:---:	|:-----:	|:-----:	|:-----:	|
|    0   	|   0   	|   0  	|   0  	|  0  	|   1   	|   1   	|   0   	|

* **TMR0ON**: habilita o TMR0;
* **T0BIT**: configura um timer de 8 bits (1) ou 16 bits (0);
* **T0CS**: fonte de clock para o TMR0. Se 0, utiliza o clock interno;
* **T0SE**: seleciona borda de descida (1) ou de subida (0) no pino TO0CKI;
* **PSA**: habilita o pre-scaler em 0;
* **T0PS**: 3 bits que selecionam 8 pre-scalers diferentes. No nosso caso, utilizaremos 110b, para um pre-scaler 1:128.

### **T1CON**

| RD16 	| T1RUN 	| T1CKPS1 	| T1CKPS0 	| T1OSCEN 	| !T1SYNC 	| TMR1CS 	| TMR1ON 	|
|:----:	|:-----:	|:-------:	|:-------:	|:-------:	|:-------:	|:------:	|:------:	|
|   1  	|   0   	|    1    	|    1    	|    0    	|    0    	|    0   	|    1   	|

* **TMR0ON**: habilita escrita/leitura do timer 1 numa operação de 16 bits;
* **T0BIT**: o dispositivo de clock é derivador do oscilador TIMER1 (1) ou de outra fonte (0);
* **T1CKPS**: 2 bits que selecionam o prescaler. Para o nosso caso, utilizaremos 11, para um prescaler de 1:8;
* **T1OSCEN**: habilita ou desabilita o oscilador do timer 1;
* **!T1SYNC**: habilita (0) a sincronização com o clock externo, se TMR1CS = 1;
* **TMR1ON**: habilita o TMR1;

## Contagem de tempo.

Um ciclo de máquina para o PIC18F4550, que possui 8MHz de clock, é de $0,5 \mu s$.  

É necessário obtermos duas contagens: uma de **1 segundos** e uma de **0,25 segundos** e, para isso, utilizaremos dois timers. A cada *overflow* do timer, uma interrupção acontece e, portanto, precisamos calcular esse overflow. Para isso: 

> $tempo = \text{ciclo de máquina} \cdot  prescaler \cdot (2^n - overflow)$

### Cálculo de overflow para 1 segundo.

Para o tempo de **1 segundo**, considerando um prescaler de **1:128**, um ciclo de máquina de $0,5 \mu s$ e um timer de **16 bits**, calcula-se:

> $1000000 = 0,5 \cdot 128 \cdot (2^{16} - overflow_{1s})$

> $1000000 = 64 \cdot (65536 - overflow_{1s})$

> $1000000 = 4194304 - 64 \cdot overflow_{1s}$

> $64 \cdot overflow_{1s} = 3194304$

> $overflow_{1s} = 49911_{10} = C2F7_{16}$

### Cálculo de overflow para 0,25 segundo.

Para o tempo de **0,25 segundo**, considerando um prescaler de **1:128**, um ciclo de máquina de $0,5 \mu s$ e um timer de **16 bits**, calcula-se:

> $250000 = 0,5 \cdot 128 \cdot (2^{16} - overflow_{0,25s})$

> $250000 = 64 \cdot (65536 - overflow_{0,25})$

> $250000 = 4194304 - 64 \cdot overflow_{0,25}$

> $64 \cdot overflow_{0,25} = 3944304$

> $overflow_{0,25} = 61630_{10} = F0BE_{16}$