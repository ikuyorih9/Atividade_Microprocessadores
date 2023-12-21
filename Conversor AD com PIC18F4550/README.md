# Conversor AD com PIC18F4550.

* Guilherme Chiarotto de Moraes (12745229);
* Hugo Hiroyuki Nakamura (12732037);

---
## 1 Principais conceitos e resultados obtidos.

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
