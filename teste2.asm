jmp menu

Msn1: string "DESEJA JOGAR NOVAMENTE? 'S/N'"
Msn2: string "FIM DE JOGO"
Msn3: string "DIGITE 'S' PARA INICIAR"

; Definição dos sprites do carro (2x2)
carroSuperior: string "<>"
carroInferior: string "=_"

; Sprites de NPCs (podem ser os mesmos)
npcCarroSuperior: string "<>"
npcCarroInferior: string "=_"

Letra: var #1        ; Contém a letra que foi digitada
posCarro: var #1     ; Contém a posição atual do carro
posAntCarro: var #1  ; Contém a posição anterior do carro

menu:
    call printtelamenuScreen

menu_loop:
    call DigLetra
    loadn r0, #'S'
    load r1, Letra
    cmp r0, r1
    jeq main
    jne menu_loop

    halt

;------------------------------
; Código principal
main:
    loadn R1, #telaCenLinha0  ; Endereço onde começa a primeira linha do cenário
    loadn R2, #0              ; Cor padrão
    call ImprimeTela          ; Rotina de impressão do cenário na tela inteira
    loadn posCarro, #580      ; Inicializa a posição do carro no centro
    call MoveCarro_Desenha    ; Desenha o carro inicial
    jmp jogo_loop

jogo_loop:
    call DigLetra             ; Lê a entrada do teclado
    call MoveCarro
    call Delay
    jmp jogo_loop

halt

;********************************************************
;                       DELAY
;********************************************************
Delay:
    push r0
    push r1
    loadn r1, #50
Delay_loop:
    loadn r0, #3000
Delay_inner_loop:
    dec r0
    jnz Delay_inner_loop
    dec r1
    jnz Delay_loop
    pop r1
    pop r0
    rts

;-------------------------------
MoveCarro:
    push r0
    push r1
    call MoveCarro_RecalculaPos  ; Atualiza a posição do carro

    ; Se posição mudou, apaga e redesenha
    load r0, posCarro
    load r1, posAntCarro
    cmp r0, r1
    jeq MoveCarro_Skip
    call MoveCarro_Apaga
    call MoveCarro_Desenha

MoveCarro_Skip:
    pop r1
    pop r0
    rts

;------------------------------
MoveCarro_RecalculaPos:  ; Recalcula posição do carro em função das teclas pressionadas
    push r0
    push r1
    push r2

    load posCarro, r0     ; Posição atual do carro
    load Letra, r1        ; Letra digitada

    ; Move para a esquerda
    loadn r2, #'a'
    cmp r1, r2
    jeq MoveCarro_Left

    ; Move para a direita
    loadn r2, #'d'
    cmp r1, r2
    jeq MoveCarro_Right

    jmp MoveCarro_Fim

MoveCarro_Left:
    mod r2, r0, #40
    cmp r2, #0
    jeq MoveCarro_Fim
    dec r0
    jmp MoveCarro_Fim

MoveCarro_Right:
    mod r2, r0, #39
    cmp r2, #38
    jeq MoveCarro_Fim
    inc r0     ; Move uma posição à direita
    jmp MoveCarro_Fim

MoveCarro_Fim:
    store posCarro, r0
    pop r2
    pop r1
    pop r0
    rts

;------------------------------
MoveCarro_Apaga:  ; Apaga o carro preservando o cenário
    push r0
    push r1
    push r2

    load posAntCarro, r0      ; Carrega posição anterior
    loadn r1, #40             ; Largura da tela

    ; Apaga a parte superior
    loadn r2, #' '            ; Espaço em branco
    outchar r2, r0
    inc r0
    outchar r2, r0

    ; Apaga a parte inferior
    add r0, r0, r1            ; Vai para a linha inferior
    dec r0
    outchar r2, r0
    inc r0
    outchar r2, r0

    pop r2
    pop r1
    pop r0
    rts

;------------------------------
MoveCarro_Desenha:  ; Desenha o carro
    push r0
    push r1
    push r2
    push r3

    load posCarro, r0         ; Carrega posição do carro
    loadn r1, #40             ; Largura da tela
    loadn r2, #carroSuperior
    call DesenhaSpriteLinha   ; Desenha a parte superior do carro

    add r0, r0, r1            ; Vai para a linha inferior
    loadn r2, #carroInferior
    call DesenhaSpriteLinha   ; Desenha a parte inferior do carro

    store posAntCarro, r0     ; Atualiza posição anterior
    pop r3
    pop r2
    pop r1
    pop r0
    rts

DesenhaSpriteLinha:
    loadi r3, r2              ; Carrega primeiro caractere
    outchar r3, r0
    inc r0                    ; Próxima coluna
    inc r2                    ; Próximo caractere
    loadi r3, r2              ; Carrega segundo caractere
    outchar r3, r0
    rts

;********************************************************
;                   DIGITE UMA LETRA
;********************************************************
DigLetra:  ; Espera que uma tecla seja digitada e salva na variável global "Letra"
    push r0
DigLetra_Loop:
    inchar r0                 ; Lê teclado
    cmp r0, #0
    jeq DigLetra_Loop         ; Se nada foi digitado, espera
    store Letra, r0           ; Salva letra digitada
    pop r0
    rts

;********************************************************
;                   IMPRIME STRING
;********************************************************
ImprimeStr:  ; Rotina de impressão de mensagens
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r3, #'\0'  ; Critério de parada

ImprimeStr_Loop:
    loadi r4, r1
    cmp r4, r3       ; If (Char == \0) vai embora
    jeq ImprimeStr_Sai
    add r4, r2, r4   ; Soma a cor
    outchar r4, r0   ; Imprime o caractere na tela
    inc r0           ; Incrementa a posição na tela
    inc r1           ; Incrementa o ponteiro da string
    jmp ImprimeStr_Loop

ImprimeStr_Sai:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;********************************************************
;                       IMPRIME TELA
;********************************************************
ImprimeTela:  ; Rotina de impressão do cenário na tela inteira
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5

    loadn r0, #0      ; Posição inicial da tela
    loadn r3, #40     ; Incremento da posição da tela
    loadn r4, #41     ; Incremento do ponteiro das linhas (40 caracteres + '\0')
    loadn r5, #1200   ; Limite da tela

ImprimeTela_Loop:
    call ImprimeStr
    add r0, r0, r3    ; Vai para a próxima linha na tela
    add r1, r1, r4    ; Incrementa o ponteiro para a próxima linha
    cmp r0, r5        ; Verifica se chegou ao fim da tela
    jl ImprimeTela_Loop

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;********************************************************
;                      TELA MENU
;********************************************************
printtelamenuScreen:

push r0
push r1
push r2
push r3
push r4
push r5
push r6

loadn r0,#0
loadn r4,#40
loadn r5,#0
loadn r2,#telamenuLinha29
loadn r1,#telamenuLinha0

printtelamenu_Loop:
    loadi r6,r1
    cmp r6,#'\0'
    jeq printtelamenu_next_line
    outchar r6, r0
    inc r1
    inc r0
    mod r3,r0,r4
    cmp r3,r5
    jne printtelamenu_Loop
printtelamenu_next_line:
    cmp r1,r2
    jl printtelamenu_Loop

pop r6
pop r5
pop r4
pop r3
pop r2
pop r1
pop r0
rts

; Declaração das linhas do menu
telamenuLinha0  : string "                                        "
telamenuLinha1  : string "                                        "
telamenuLinha2  : string "                                        "
telamenuLinha3  : string "                                        "
telamenuLinha4  : string "                                        "
telamenuLinha5  : string "                                        "
telamenuLinha6  : string "                                        "
telamenuLinha7  : string "                                        "
telamenuLinha8  : string "                                        "
telamenuLinha9  : string "                                        "
telamenuLinha10 : string "    ********************************    "
telamenuLinha11 : string "    *   CLIQUE 'S' PARA INICIAR    *    "
telamenuLinha12 : string "    ********************************    "
telamenuLinha13 : string "                                        "
telamenuLinha14 : string "                                        "
telamenuLinha15 : string "                                        "
telamenuLinha16 : string "                                        "
telamenuLinha17 : string "                                        "
telamenuLinha18 : string "                                        "
telamenuLinha19 : string "                                        "
telamenuLinha20 : string "                                        "
telamenuLinha21 : string "                                        "
telamenuLinha22 : string "                                        "
telamenuLinha23 : string "                                        "
telamenuLinha24 : string "                                        "
telamenuLinha25 : string "                                        "
telamenuLinha26 : string "                                        "
telamenuLinha27 : string "                                        "
telamenuLinha28 : string "                                        "
telamenuLinha29 : string "                                        "

;********************************************************
;                  DECLARAÇÃO DO CENÁRIO
;********************************************************
telaCenLinha0  : string "          z                     z       "
telaCenLinha1  : string "          z                     z       "
telaCenLinha2  : string "          z                     z       "
telaCenLinha3  : string "          z                     z       "
telaCenLinha4  : string "          z                     z       "
telaCenLinha5  : string "          z                     z       "
telaCenLinha6  : string "          z                     z       "
telaCenLinha7  : string "          z                     z       "
telaCenLinha8  : string "          z                     z       "
telaCenLinha9  : string "          z                     z       "
telaCenLinha10 : string "          z                     z       "
telaCenLinha11 : string "          z                     z       "
telaCenLinha12 : string "          z                     z       "
telaCenLinha13 : string "          z                     z       "
telaCenLinha14 : string "          z                     z       "
telaCenLinha15 : string "          z                     z       "
telaCenLinha16 : string "          z                     z       "
telaCenLinha17 : string "          z                     z       "
telaCenLinha18 : string "          z                     z       "
telaCenLinha19 : string "          z                     z       "
telaCenLinha20 : string "          z                     z       "
telaCenLinha21 : string "          z                     z       "
telaCenLinha22 : string "          z                     z       "
telaCenLinha23 : string "          z                     z       "
telaCenLinha24 : string "          z                     z       "
telaCenLinha25 : string "          z                     z       "
telaCenLinha26 : string "          z                     z       "
telaCenLinha27 : string "          z                     z       "
telaCenLinha28 : string "          z                     z       "
telaCenLinha29 : string "          z                     z       "

;********************************************************
;                      APAGA TELA
;********************************************************
ApagaTela:
    push r0
    push r1

    loadn r0, #1200     ; Apaga as 1200 posições da tela
    loadn r1, #' '      ; Com espaço

ApagaTela_Loop:
    dec r0
    outchar r1, r0
    jnz ApagaTela_Loop

    pop r1
    pop r0
    rts
