#line 1 "H:/Meu Drive/Aplicação de Microprocessadores/Atividade_Microprocessadores/Conversor AD com PIC18F4550/ConversorAD.c"
#line 31 "H:/Meu Drive/Aplicação de Microprocessadores/Atividade_Microprocessadores/Conversor AD com PIC18F4550/ConversorAD.c"
sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;



void main(){

 unsigned int Valor_ADC = 0;
 unsigned char Tensao[10];


 TRISA.RA5 = 1;
 ADCON1 = 0B00000000;



 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"ADC0:");

 ADC_Init();


 while( 1 )
 {
 Valor_ADC = ADC_Read(4);







 Valor_ADC = Valor_ADC * (1234/1023.);



 Tensao[0] = (Valor_ADC/1000) + '0';



 Tensao[1] = (Valor_ADC/100)%10 + '0';



 Tensao[2] = '.';

 Tensao[3] = (Valor_ADC/10)%10 + '0';

 Tensao[4] = (Valor_ADC/1)%10 + '0';

 Tensao[5] = 0;









 Lcd_Out(1,6,Tensao);
 Delay_ms(20);
 }
}
