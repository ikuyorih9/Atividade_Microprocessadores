int contagem;
int bcd[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67};

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
    TRISA = 0; //Define a porta A como saída.
    PORTA = 0x0F; //Define todos os valores da porta A com nível baixo (0).
    TRISD = 0;  //Define a porta D como saída.
    PORTD = 0;  //Define todos os valores da porta D com nível baixo (0).
    TRISB = 1 //Define a porta B como entrada.
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