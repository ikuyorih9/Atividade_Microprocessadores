# Conversor AD com PIC18F4550.

* Guilherme Chiarotto de Moraes (12745229);
* Hugo Hiroyuki Nakamura (12732037);

---
## 1 Principais conceitos e resultados obtidos.
O circuito usa um potenciômetro (resistor variável) conectado à porta analógica AN4 de um microcontrolador PIC18F4550. A tensão no potenciômetro é medida pelo conversor analógico para digital (ADC) do microcontrolador. Essa tensão é então convertida em uma representação digital e exibida em um display LCD.

### 1.1 Funcionamento do potenciômetro
O potenciômetro é conectado a uma porta analógica (AN4 no código) e funciona como um divisor de tensão. A posição do potenciômetro determina a tensão na porta analógica. 

O código, portanto, lê continuamente a tensão no potenciômetro, ajusta a escala e exibe a tensão no LCD. O usuário verá um valor numérico que representa a tensão medida em uma determinada escala.

### 1.2 Configuração do LCD
O display LCD está conectado ao microcontrolador PIC por meio de seis pinos, que são definidos no início do código usando a biblioteca sbit. A direção do fluxo de dados é configurada através dos pinos TRISBx_bit, onde x é o número do pino. Isso define quais pinos serão usados como entradas e saídas para o LCD.

### 1.3 Inicialização do LCD
A biblioteca Lcd_Init() é utilizada para inicializar o LCD. Lcd_Cmd(_LCD_CLEAR) limpa a tela do LCD, e Lcd_Cmd(_LCD_CURSOR_OFF) desliga o cursor. A função Lcd_Out(1,1,"ADC0:") escreve o texto "ADC0:" na posição (1,1) do LCD.

### 1.4 Configuração do ADC
O ADCON1 é configurado para garantir que as portas sejam analógicas (ADCON1 = 0B00000000;). A função ADC_Init() faz a inicialização do módulo ADC.

### 1.5 Loop Principal
Dentro do loop principal (while(1)), o programa entra em um loop infinito onde a leitura do ADC é realizada continuamente.

#### 1.5.1 Leitura do ADC
```
Valor_ADC = ADC_Read(4);
```
Isso lê o valor analógico da porta AN4 (A5) e armazena em Valor_ADC. O valor lido está na faixa de 0 a 1023.

#### 1.5.2 Ajuste da leitura e formatação

```
Valor_ADC = Valor_ADC * (1234/1023.);
```
Este trecho ajusta o valor lido do ADC para a faixa de 0 a 1234. Essa é uma correção de escala para refletir a faixa real de tensão que está sendo medida.

```
Tensao[0] = (Valor_ADC/1000) + '0';
Tensao[1] = (Valor_ADC/100)%10 + '0';
Tensao[2] = '.';
Tensao[3] = (Valor_ADC/10)%10 + '0';
Tensao[4] = (Valor_ADC/1)%10 + '0';
Tensao[5] = 0;
```
Estes comandos convertem o valor ajustado em uma string de caracteres (Tensao), representando a tensão. Os valores são convertidos em dígitos ASCII e armazenados na string.

#### 1.5.3 Exibição no LCD

```
Lcd_Out(1,6,Tensao);
```
Coloca a string Tensao no LCD, começando na posição (1,6).

#### 1.5.4 Delay

```
Delay_ms(20);
```
Atraso adicionado para garantir que o LCD tenha tempo suficiente para processar e exibir as informações.

### 1.6 Resultados e funcionamento geral

#### 1.6.1 Potenciômetro (Resistor Variável)
Ao girar o potenciômetro, você altera a resistência entre seus terminais, o que, por sua vez, altera a tensão na porta analógica (AN4).

Isso permite ajustar a tensão de entrada no microcontrolador, que é então medida pelo ADC.

#### 1.6.2 Exibição no LCD
O LCD mostra a tensão medida em tempo real, representada como uma string de caracteres.

Ao girar o potenciômetro, a string no LCD deve ser atualizada para refletir a nova tensão medida.

#### Display com valor de tensão float
O valor da tensão é convertido em uma string (Tensao) e exibido no LCD. No entanto, os microcontroladores geralmente não suportam operações de ponto flutuante diretamente.

A exibição de ponto flutuante é simulada pela representação dos dígitos decimais. Por exemplo, "1234" pode ser exibido como "12.34".

O código converte a tensão medida em uma representação decimal, permitindo que o usuário visualize a tensão com precisão de duas casas decimais.

---
## 2 Circuito no Simulide.

O código foi simulado no Simulide, segundo o esquemático abaixo.

<p align="center">
    <img width = 600 src="imgs/Figura - circuito conversor AD.png">
</p>

<p align=center> 
    <b>Imagem 1: esquemático do circuito no Simulide.</b>
</p>

## 3 Código comentado.

```
//PINOS DO LCD.
sbit LCD_RS at LATB4_bit; // Porta RS do LCD em B4 do PIC.
sbit LCD_EN at LATB5_bit; // Porta EN do LCD em B5 do PIC.
sbit LCD_D4 at LATB0_bit; // Porta D4 do LCD em B0 do PIC.
sbit LCD_D5 at LATB1_bit; // Porta D5 do LCD em B1 do PIC.
sbit LCD_D6 at LATB2_bit; // Porta D6 do LCD em B2 do PIC.
sbit LCD_D7 at LATB3_bit; // Porta D7 do LCD em B3 do PIC.

//DIREÇÃO DO FLUXO DE DADOS.
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;


void main(){

  unsigned int Valor_ADC = 0;  //Leitura ADC da entrada.
  unsigned char Tensao[10];    //Array de char para o texto no display.

  TRISA.RA5 = 1; //Configura a porta A5 como entrada.
  ADCON1 = 0B00000000; //Configura as portas AN como analógicas.


  //INICIALIZAÇÃO DO MÓDULO LCD.
  Lcd_Init();                 //Inicializa o display LCD.
  Lcd_Cmd(_LCD_CLEAR);       //Limpa a tela do display.
  Lcd_Cmd(_LCD_CURSOR_OFF);  //Desliga o cursor.
  Lcd_Out(1,1,"ADC0:");   //Escreve na posição (1,1) o texto "ADC0:".

  ADC_Init();  //Inicializa o módulo ADC.

  while(1){
    //OBTENÇÂO DO VALOR ADC.
    Valor_ADC = ADC_Read(4); //Lê o valor de tensão, de 0 a 1023, da porta AN4 (A5).
    Valor_ADC = Valor_ADC * (1234/1023.); //Formatando  de 0->1023 para 0->1234.

    //FORMATAÇÃO DO TEXTO PARA O DISPLAY.
    Tensao[0] = (Valor_ADC/1000) + '0'; //Obtém o primeiro digito de Valor_ADC e converte para um valor ASCII.
    Tensao[1] = (Valor_ADC/100)%10 + '0'; //Obtém o segundo digito de Valor_ADC e converte para um valor ASCII.
    Tensao[2] = '.'; //Adiciona um ponto.
    Tensao[3] = (Valor_ADC/10)%10 + '0'; //Obtém o terceiro digito de Valor_ADC e converte para um valor ASCII.
    Tensao[4] = (Valor_ADC/1)%10 + '0';  //Obtém o último digito de Valor_ADC e converte para um valor ASCII.
    Tensao[5] = 0; //Indicador de fim de string.

    Lcd_Out(1,6,Tensao); //Põe o texto de Tensao no display na posição (1,6).
    Delay_ms(20); //Delay para o display.
  }
}
```
