# Cronometro Digital com PIC18F4550.

* Guilherme Chiarotto de Moraes ();
* Hugo Hiroyuki Nakamura (12732037);

---

## 1 Conceitos envolvidos e resultados obtidos.

O projeto do cronometro digital com o PIC18F4550 tem o funcionamento centrado na utilização de interrupções, o uso dos registradores internos e de componentes agregados, como dois botões e um display de 7 segmentos.

A interrupção acontece de duas maneiras: através de botões ou de timers. Toda vez que uma interrupção acontece, seja porque o botão foi pressionado, ou porque ocorreu overflow no timer, uma função é chamada em código. Assim, pode-se usar interrupções para executar atividades específicas.

No caso, a interrupção que ocorre por botões inicia os timers. Se o botão em RB0 for pressionado, o timer TMR0 é chamado, com overflow em 1 segundo. Se o botão em RB1 for pressionado, o timer TMR1 é chamado, com overflow em 250 milissegundos. Ao ocorrer a interrupção dos timers por overflow, a contagem deve ser incrementada e mostrada no display de 7 segmentos.

---

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

---

### 1.2 Interrupção por timer.

A interrupção por timers utiliza as interrupções **TMR0** e **TMR1**, configuradas pelos registradores T0CON e T1CON da seguinte forma:

#### 1.2.1 T0CON.

| TMR0ON 	| T0BIT 	| T0CS 	| T0SE 	| PSA 	| T0PS2 	| T0PS1 	| T0PS0 	|
|:------:	|:-----:	|:----:	|:----:	|:---:	|:-----:	|:-----:	|:-----:	|
|    0   	|   0   	|   0  	|   0  	|  0  	|   1   	|   1   	|   0   	|

<p align=center> 
    <b>Tabela 4: registrador T0CON com os valores usados no projeto.</b>
</p>

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

<p align=center> 
    <b>Tabela 5: registrador T1CON com os valores usados no projeto.</b>
</p>

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

Um ciclo de máquina para o PIC18F4550, que possui 8MHz de clock, é de $0,5 \mu s$.  

É necessário obtermos duas contagens: uma de **1 segundos** e uma de **0,25 segundos** e, para isso, utilizaremos dois timers. A cada *overflow* do timer, uma interrupção acontece e, portanto, precisamos calcular esse overflow. Para isso: 

> $tempo = \text{ciclo de máquina} \cdot  prescaler \cdot (2^n - overflow)$

Para o tempo de **1 segundo**, considerando um prescaler de **1:128**, um ciclo de máquina de $0,5 \mu s$ e um timer de **16 bits**, calcula-se:

> $1000000 = 0,5 \cdot 128 \cdot (2^{16} - overflow_{1s})$

> $1000000 = 64 \cdot (65536 - overflow_{1s})$

> $1000000 = 4194304 - 64 \cdot overflow_{1s}$

> $64 \cdot overflow_{1s} = 3194304$

> $overflow_{1s} = 49911_{10} = C2F7_{16}$

Para o tempo de **0,25 segundo**, considerando um prescaler de **1:8**, um ciclo de máquina de $0,5 \mu s$ e um timer de **16 bits**, calcula-se:

> $250000 = 0,5 \cdot 8 \cdot (2^{16} - overflow_{0,25s})$

> $250000 = 4 \cdot (65536 - overflow_{0,25})$

> $250000 = 262144 - 4 \cdot overflow_{0,25}$

> $4 \cdot overflow_{0,25} = 12144$

> $overflow_{0,25} = 3036_{10} = 0BDC_{16}$

### 1.3 Display de 7 segmentos.

O display de 7 segmentos está conectado na porta D do PIC18F4550, controlada pelo registrador PORTD.

<p align=center>

| **Segmento** 	| **Bit PORTD** 	|
|:------------:	|:-------------:	|
|       a      	|      RD0      	|
|       B      	|      RD1      	|
|       c      	|      RD2      	|
|       d      	|      RD3      	|
|       e      	|      RD4      	|
|       f      	|      RD5      	|
|       g      	|      RD6      	|
|      dp      	|      RD7      	|
</p>
<p align=center> 
    <b>Tabela 6: mapeamento do segmento do display de 7 segmentos para as portas D.</b>
</p>

Assim, a contagem decimal pode ser convertida para a contagem BCD 7 SEG, ligando os segmentos certos para formar o número decimal no display.

<p align=center>

| **Contagem** 	| **BCD 7 SEG (binário)** 	| **BCD 7 SEG (Hexadecimal)** 	|
|:------------:	|:----------------------:	|:--------------------------:	|
|       0      	|        00111111        	|            0x3F            	|
|       1      	|        00000110        	|            0x06            	|
|       2      	|        01011011        	|            0x5B            	|
|       3      	|        01001111        	|            0x4F            	|
|       4      	|        01100110        	|            0x66            	|
|       5      	|        01101101        	|            0x6D            	|
|       6      	|        01111101        	|            0x7D            	|
|       7      	|        00000111        	|            0x07            	|
|       8      	|        01111111        	|            0x7F            	|
|       9      	|        01100111        	|            0x67            	|
</p>

<p align=center> 
    <b>Tabela 7: conversão da contagem decimal para contagem BCD 7 SEG.</b>
</p>

Dada uma interrupção de timer, que executa um incremento de contagem, é possível passar o valor hexadecimal (ou binário) para o registrador PORTD e o display mostrará o número atual da contagem.

### 1.4 Vantagens e desvantagens do PIC18F4550 em relação ao 8051.

No projeto do cronometro utilizando o 8051, a verificação do clique de um botão era feita de forma sequencial, isto é, não havia processamento paralelo e as execuções em Assembly não era realizadas enquanto o delay estivesse em execução. Isso pode gerar alguns atrasos (embora curtos) na contagem.

Ao utilizar as interrupções do PIC18F4550, a interrupção gerada por um botão independe da contagem do timer. Logo, ao clicar em qualquer um dos botões, a função da interrupção é executada paralelamente ao timer, deixando a contagem mais precisa e imediata.

Além disso, o PIC18F4550 pode ser programado na linguagem C, que é muito mais simples e intuitiva que Assembly, facilitando a execução de projetos. Mas, o 8051 tem a vantagem de apresentar uma plataforma unificada, com codificação, simulação e controle dos registradores na mesma tela.

## 2 Circuito no Simulide.

O código foi simulado no Simulide, segundo o esquemático abaixo.

<p align="center">
    <img width = 600 src="imgs/Figura - esquemático SIMULIDE.png">
</p>

<p align=center> 
    <b>Imagem 1: esquemático do circuito no Simulide.</b>
</p>

Para se aproximar ao Kit EasyPIC v7, vários elementos da placa são colocados no esquemático, como as chaves SW4, SW5 e SW6, com seus resistores, e o transistor BC856B.

A porta A0 não é exigida para o funcionamento do circuito e nem está na especificação do projeto, mas ela é importante para atestar o tempo de contagem correto. Quando a interrupção por timer ocorre, ela inverte o estado lógico da porta A0, gerando um duty cycle de 50%. Dessa forma, se o timer de **1 segundo** é selecionado, a frequência deve ser **0,5 Hz** (1 segundo ligado e 1 segundo desligado); se o timer de **0,25 segundos** é selecionado, a frequência deve ser **2 Hz** (0,25 segundo ligado e 0,25 segundo desligado).

## 3 Código comentado.

```
int contagem; // Valor atual da contagem.
const int bcd[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67}; //Mapeamento decimal para BCD7SEG.

/**
 * Mostra o valor atual da contagem no display 7seg e conta o cronometro.
*/
void conta(){
    PORTD = bcd[contagem]; //Mostra o valor atual da contagem no display.
    contagem++; //Aumenta a contagem.
    if(contagem > 9) //Reinicia a contagem se ela passar de 9.
        contagem = 0;
}

/**
 * Acionado quando ocorre uma interrupção em hardware.
*/
void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO{
    //Verifica se ocorreu a interrupção INT0.
    if(INTCON.INT0IF == 1){
        T0CON.TMR0ON = 1; //Inicia o timer TMR0 (1s).
        T1CON.TMR1ON = 0; //Para o timer TMR1 (0,25s).
        INTCON.INT0IF = 0; //Zera a flag de INT0.
    }    
    
    //Verifica se ocorreu a interrupção INT1.
    if(INTCON3.INT1IF == 1){
        INTCON3.INT1IF = 0; //Para o timer TMR0 (1s).
        T0CON.TMR0ON = 0; //Inicia o timer TMR1 (0,25s).
        T1CON.TMR1ON = 1; //Zera a flag de INT1.
    }

    //Verifica se ocorreu a interrupção TMR0.
    if(INTCON.TMR0IF == 1){
        PORTA.RA0 ^= 1; //Muda o estado lógico da porta A0.
        conta(); //Realiza a contagem.
        TMR0H = 0xC2; //Atualiza o primeiro byte de TMR0.
        TMR0L = 0xF7; //Atualiza o último byte de TMR0.
        INTCON.TMR0IF = 0; //Zera a flag de TMR0.
    }

    //Verifica se ocorreu a interrupção TMR0.
    if(PIR1.TMR1IF == 1){
        PORTA.RA0 ^= 1; //Muda o estado lógico da porta A0.
        conta(); //Realiza a contagem.
        TMR1H = 0x0B; //Atualiza o primeiro byte de TMR1.
        TMR1L = 0xDC; //Atualiza o último byte de TMR0.
        PIR1.TMR1IF = 0; //Zera a flag de TMR1.
    }
}


void main(){
    //CONFIGURA AS PORTAS USADAS.
    ADCON1 |= 0X0F; //Define os pinos na porta B como entradas digitais (00001111).
    TRISA = 0x00; //Define a porta A como saída.
    PORTA = 0x00; //Define todos os valores da porta A com nível baixo (0).
    TRISD = 0x00;  //Define a porta D como saída.
    PORTD = 0x00;  //Define todos os valores da porta D com nível baixo (0).
    TRISB = 0x0F; //Define a porta B como entrada.
    INTCON2.RBPU = 0; //Habilita chave global de resistores de pull-up na porta B.


    //CONFIGURA OS NÍVEIS DE INTERRUPÇÃO.
    RCON.IPEN = 1; //Habilita os níveis de interrupção.
    INTCON.GIEH = 1; //Habilita AS interrupções de alta prioridade se IPEN = 1.
    INTCON3.INT1IP = 1; //Habilita a alta prioridade para a interrupção 1.
    IPR1.TMR1IP = 1; //Habilita a alta prioridade para a TMR1.


    //CONFIGURA AS INTERRUPÇÕES.
    INTCON.INT0IE = 1; //Habilita interrupção externa na porta INT0.
    INTCON3.INT1IE = 1; //Habilita a interrupção externa na porta INT1.
    INTCON.TMR0IE = 1; //Habilita a interrupção do timer TMR0.
    PIE1.TMR1IE = 1; //Habilita a interrupção do timer TMR1.


    //ZERA AS FLAGS DE INTERRUPÇÃO.
    INTCON.INT0IF = 0; //Zera a flag de interrupção na porta INT0.
    INTCON3.INT1IF = 0; //Zera a flag de interrupção na porta INT1.
    INTCON.TMR0IF = 0;  //Zera a flag de interrupção do timer TMR0.
    PIR1.TMR1IF = 0; //Zera a flag de interrupção do timer TMR1

    //DEFINIÇÃO DOS TEMPOS DO TIMER.
    TMR0H = 0xC2; //Primeiro byte do TMR0.
    TMR0L = 0xF7; //Último byte do TMR0.
    TMR1H = 0x0B; //Primeiro byte do TMR1.
    TMR1L = 0xDC; //Último byte do TMR1.

    //OUTRAS CONFIGURAÇÕES.
    INTCON2.INTEDG0 = 1; //Habilita a borda de subida na INT0.
    T0CON = 0b00000110; //Configura o registrador T0CON, referente ao TMR0.
    T1CON = 0b10110000; //Configura o registrador T1CON, referente ao TMR1.
    contagem = 0; //Começa a contagem em 0.

    while(1); //Segura o processamento.
}
```