#line 1 "H:/Meu Drive/Aplicação de Microprocessadores/Atividade_Microprocessadores/Cronometro digital com PIC18F4550/CronometroDigitalPIC18F4550.c"
int contagem;
const int bcd[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67};
#line 7 "H:/Meu Drive/Aplicação de Microprocessadores/Atividade_Microprocessadores/Cronometro digital com PIC18F4550/CronometroDigitalPIC18F4550.c"
void conta(){
 PORTD = bcd[contagem];
 contagem++;
 if(contagem > 9)
 contagem = 0;
}
#line 17 "H:/Meu Drive/Aplicação de Microprocessadores/Atividade_Microprocessadores/Cronometro digital com PIC18F4550/CronometroDigitalPIC18F4550.c"
void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO{

 if(INTCON.INT0IF == 1){
 T0CON.TMR0ON = 1;
 T1CON.TMR1ON = 0;
 INTCON.INT0IF = 0;
 }


 if(INTCON3.INT1IF == 1){
 INTCON3.INT1IF = 0;
 T0CON.TMR0ON = 0;
 T1CON.TMR1ON = 1;
 }


 if(INTCON.TMR0IF == 1){
 PORTA.RA0 ^= 1;
 conta();
 TMR0H = 0xC2;
 TMR0L = 0xF7;
 INTCON.TMR0IF = 0;
 }


 if(PIR1.TMR1IF == 1){
 PORTA.RA0 ^= 1;
 conta();
 TMR1H = 0x0B;
 TMR1L = 0xDC;
 PIR1.TMR1IF = 0;
 }
}


void main(){

 ADCON1 |= 0X0F;
 TRISA = 0x00;
 PORTA = 0x00;
 TRISD = 0x00;
 PORTD = 0x00;
 TRISB = 0x0F;
 INTCON2.RBPU = 0;



 RCON.IPEN = 1;
 INTCON.GIEH = 1;
 INTCON3.INT1IP = 1;
 IPR1.TMR1IP = 1;



 INTCON.INT0IE = 1;
 INTCON3.INT1IE = 1;
 INTCON.TMR0IE = 1;
 PIE1.TMR1IE = 1;



 INTCON.INT0IF = 0;
 INTCON3.INT1IF = 0;
 INTCON.TMR0IF = 0;
 PIR1.TMR1IF = 0;


 TMR0H = 0xC2;
 TMR0L = 0xF7;
 TMR1H = 0x0B;
 TMR1L = 0xDC;


 INTCON2.INTEDG0 = 1;
 T0CON = 0b00000110;
 T1CON = 0b10110000;
 contagem = 0;

 while(1);
}
