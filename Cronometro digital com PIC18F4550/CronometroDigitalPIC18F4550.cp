#line 1 "H:/Meu Drive/Aplicação de Microprocessadores/Atividade_Microprocessadores/Cronometro digital com PIC18F4550/CronometroDigitalPIC18F4550.c"
int contagem;
int bcd[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67};

void conta(){
 PORTD = bcd[contagem];
 contagem++;
 if(contagem > 9)
 contagem = 0;
}

void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO{
 if(INTCON.INT0IF == 1){
 INTCON.INT0IF = 0;

 T0CON.TMR0ON = 1;
 T1CON.TMR1ON = 0;
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

 INTCON2.RBPU = 0;

 TRISD = 0;
 PORTD = 0;

 RCON.IPEN = 1;


 INTCON.GIEH = 1;
 INTCON.INT0IE = 1;
 INTCON.INT0IF = 0;
 INTCON.TMR0IE = 1;
 INTCON.TMR0IF = 0;


 INTCON2.INTEDG0 = 1;


 INTCON3.INT1IP = 1;
 INTCON3.INT1IE = 1;
 INTCON3.INT1IF = 0;


 T0CON = 0b00000110;


 T1CON = 0b10110000;
 PIE1.TMR1IE = 1;


 TMR0H = 0xC2;
 TMR0L = 0xF7;

 TMR1H = 0x0B;
 TMR1L = 0xDC;
 PIR1.TMR1IF = 0;
 IPR1.TMR1IP = 1;

 TRISB.RB0 = 1;
 TRISB.RB1 = 1;

 TRISA = 0;
 PORTA = 0x0F;

 contagem = 0;

 while(1);
}
