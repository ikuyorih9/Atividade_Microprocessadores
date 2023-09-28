org 00h

inicio:
MOV ACC,#02 ;Transfere o valor 2 em decimal para o registrador ACC
MOV B,#03 ;Transfere o valor 3 em decimal para o registrador B
MOV 022h,#07 ;Transfere o valor 7 em decimal para o endereço 22 da memória
ADD A,022h ;Soma o conteúdo do endereço de memória 22 com o ACC
DEC A,#03 ;Decrementa 3 unidades do registrador ACC
INC B ;Incrementa 1 unidade no registrador B
SUBB B,A ;Subtrai o conteúdo de A por B
MUL AB ;Multiplica A por B
INC B,#02 ;Incrementa 2 unidades no registrador B
DIV B,A ;Divide A por B
;NÃO SEI MAIS :(((
STO
