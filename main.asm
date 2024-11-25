jmp menu



Msn1: string "DESEJA JOGAR NOVAMENTE? 'S/N'"
Msn2: string "FIM DE JOGO"
Msn3: string "DIGITE 'S' PARA INICIAR"

Letra: var #1		; Contem a letra que foi digitada

posCarro: var #1017			; Contem a posicao atual da Carro
posAntCarro: var #1016		; Contem a posicao anterior da Carro
status: var #0     ;status 0=vivo, 1=morto


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
;Codigo principal
main:
	
	loadn R1, #telaCenLinha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #1024  			; cor branca!
	
	Move_main:

		call ImprimeTela   		;  Rotina de Impresao de Cenario na Tela Inteira
		call MoveCarro
	
	loadn r0,#'0'
	load r0, status
	jnz Move_main

	call printtelafimScreen

	menu_fim:	
		call DigLetra
		loadn r0, #'S'
		load r1, Letra
		cmp r0, r1			
		jeq main
		loadn r0, #'N'
		cmp r0,r1
		jne fim

		finalizando_menu_fim_funcao:
			call finalizando_menu
			call DigLetra
			loadn r0, #'M'
			load r1, Letra
			cmp r0, r1
			jeq main
			jne menu

	fim:
	
halt

;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push r0
	Push r1
	
	Loadn r1, #50  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn r0, #3000	; b
   Delay_volta: 
	Dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec r1
	JNZ Delay_volta2
	
	Pop r1
	Pop r0
	
	rts					;return

;-------------------------------

MoveCarro:
	push r0
	push r1
	
	call MoveCarro_RecalculaPos		; Recalcula Posicao da Carro

; So' Apaga e Redesenha se (pos != posAnt)
;	If (posCarro != posAntCarro)	{	
	load r0, posCarro
	load r1, posAntCarro
	cmp r0, r1
	jeq MoveCarro_Skip
		call MoveCarro_Apaga
		call MoveCarro_Desenha		;}
  MoveCarro_Skip:
	
	pop r1
	pop r0
	rts
;------------------------------

	
MoveCarro_RecalculaPos:		; Recalcula posicao da Carro em funcao das Teclas pressionadas
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6

	load r0, posCarro
	
	loadn r1, #'d'
	loadn r2, #'d'
	cmp r1, r2
	jeq MoveCarro_RecalculaPos_D
	
	loadn r1,#'a'
	loadn r2, #'a'
	cmp r1, r2
	jeq MoveCarro_RecalculaPos_A


  MoveCarro_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posCarro, r0
	
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

MoveCarro_RecalculaPos_A:	; Move Carro para Esquerda

	call MoveCarro_Apaga
	loadn r1, #40
	loadn r0, #posCarro
	loadn r2,#11
	mod r1, r0, r1		; Testa condicoes de Contorno 
	cmp r1, r2
	jeq MoveCarro_RecalculaPos_Fim
	dec r0	; pos = pos -1
	jmp MoveCarro_RecalculaPos_Fim
		
  MoveCarro_RecalculaPos_D:	; Move Carro para Direita
  
  	call MoveCarro_Apaga
	loadn r1,#6
	loadn r0, #posCarro
	add r0,r1,r0
	loadn r1,#40
	loadn r2,#29
	mod r1, r0, r1		; Testa condicoes de Contorno 
	cmp r1, r2
	jeq MoveCarro_RecalculaPos_Fim
	dec r0	; pos = pos -1
	jmp MoveCarro_RecalculaPos_Fim
	

MoveCarro_Apaga:		; Apaga a Carro preservando o Cenario!
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	load r0, posAntCarro	; R0 = posAnt
	loadn r6,#16
	loadn r1, #telaCenLinha26	; Endereco onde comeca a primeira linha do cenario!!
	add r2, r1, r6	; R2 = Tela1Linha0 + posAnt
	
	loadi r5, r2	; R5 = Char (Tela(posAnt))
	
	outchar r5, r0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;------------------


MoveCarro_Desenha:	; Desenha caracter do Carro
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	loadn r3,#'r'
	load r0,posCarro
	outchar r3,r0
	
	MoveCarro_Desenha_Fim:
		store posAntCarro, r0	; Atualiza Posicao Anterior da Carro = Posicao Atual
		
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts

;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	
	loadn r1, #'S'

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado
		cmp r0, r1			; compara r0 com o código da tabela ASCII de S
		jne DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts



;********************************************************
;                   FINALIZANDO O JOGO
;********************************************************

finalizando_menu:
	call printtelaXUPAFEDERALScreen
rts

;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                   IMPRIME CENÁRIO
;********************************************************
	
ImprimeCenario:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeCenario_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeCenario_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeCenario_Loop
	
   ImprimeCenario_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; Declara uma tela vazia para ser preenchida em tempo de execussao:

telaCenLinha0  : string " %        *         )        *    '+(   "
telaCenLinha1  : string "          *                  *    g,h   "
telaCenLinha2  : string "      %   *         )        *     &    "
telaCenLinha3  : string "          *                  *     &    "
telaCenLinha4  : string " %        *         )        *     &    " 
telaCenLinha5  : string "   '+(    *                  *  %       "
telaCenLinha6  : string "   g,h    *         )        *        % "
telaCenLinha7  : string "    &     *                  *          "
telaCenLinha8  : string "    &     *         )        *  %       "
telaCenLinha9  : string "    &     *                  *          "
telaCenLinha10 : string " %        *         )        *    '+(   "
telaCenLinha11 : string "          *                  *    g,h   "
telaCenLinha12 : string "       %  *         )        *     &    "
telaCenLinha13 : string "          *                  *     &    "
telaCenLinha14 : string " %        *         )        *     &    "
telaCenLinha15 : string "   '+(    *                  * %        "
telaCenLinha16 : string "   g,h    *         )        *          "
telaCenLinha17 : string "    &     *                  *       %  "
telaCenLinha18 : string "    &     *         )        *          "
telaCenLinha19 : string "    &     *                  * %        "
telaCenLinha20 : string "          *         )        *    '+(   "
telaCenLinha21 : string " %        *                  *    g,h   "
telaCenLinha22 : string "          *         )        *     &    "
telaCenLinha23 : string "       %  *                  *     &    "
telaCenLinha24 : string " %        *         )        *     &    "
telaCenLinha25 : string "   '+(    *                  *          "
telaCenLinha26 : string "   g,h    *         )        * %        "
telaCenLinha27 : string "    &     *                  *          "
telaCenLinha28 : string "    &     *         )        *       %  "
telaCenLinha29 : string "    &     *                  *          "



;********************************************************
;                      APAGA TELA
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	
	
;------------------------	
; Declara uma tela vazia para ser preenchida em tempo de execução:

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "	

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
	
loadn r0,#40 
loadn r4,#40
loadn r5,#0
loadn r2,#telamenuLinha29
add r2,r2,r0
loadn r0,#0
loadn r1,#telamenuLinha0

   printtelamenu_Loop:
   	loadi r6,r1
	outchar r6, r0
	inc r1
	inc r0
	mod r3,r0,r4
	cmp r3,r5
	jne printtelamenu_skip
	inc r1
	printtelamenu_skip:
		cmp r1,r2
		jne printtelamenu_Loop

pop r6
pop r5
pop r4
pop r3
pop r2
pop r1	
pop r0
rts	

;declara uma tela para ser o menu

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
telamenuLinha10 : string "      saaaaaaaaaaaaaaaaaaaaaaaaaac      "
telamenuLinha11 : string "      b  CLIQUE 'S' PARA JOGAR!  b      "
telamenuLinha12 : string "      daaaaaaaaaaaaaaaaaaaaaaaaaai      "
telamenuLinha13 : string "                                        "
telamenuLinha14 : string "                  op                    "
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
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                      TELA FIM
;********************************************************

printtelafimScreen:

push r0
push r1
push r2
push r3
push r4
push r5
push r6
	
loadn r0,#40 
loadn r4,#40
loadn r5,#0
loadn r2,#telafimLinha29
add r2,r2,r0
loadn r0,#0
loadn r1,#telafimLinha0

   printtelafim_Loop:
   	loadi r6,r1
	outchar r6, r0
	inc r1
	inc r0
	mod r3,r0,r4
	cmp r3,r5
	jne printtelafim_skip
	inc r1
	printtelafim_skip:
		cmp r1,r2
		jne printtelafim_Loop
		
pop r6
pop r5
pop r4
pop r3
pop r2
pop r1	
pop r0
rts	

;declara uma tela para ser o fim do jogo

telafimLinha0  : string "                                        "
telafimLinha1  : string "                                        "
telafimLinha2  : string "                                        "
telafimLinha3  : string "                                        "
telafimLinha4  : string "                                        "
telafimLinha5  : string "                                        "
telafimLinha6  : string "                                        "
telafimLinha7  : string "                                        "
telafimLinha8  : string "                                        "
telafimLinha9  : string "                                        "
telafimLinha10 : string "  saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac  "
telafimLinha11 : string "  b           VOCÊ MORREU!           b  "
telafimLinha12 : string "  b CLIQUE 'S' PARA JOGAR NOVAMENTE/ b  "
telafimLinha13 : string "  b  OU 'N' PARA VOLTAR PARA O MENU  b  "
telafimLinha14 : string "  daaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaai  "
telafimLinha15 : string "                   op                   "
telafimLinha16 : string "                                        "
telafimLinha17 : string "                                        "
telafimLinha18 : string "                                        "
telafimLinha19 : string "                                        "
telafimLinha20 : string "                                        "
telafimLinha21 : string "                                        "
telafimLinha22 : string "                                        "
telafimLinha23 : string "                                        "
telafimLinha24 : string "                                        "
telafimLinha25 : string "                                        "
telafimLinha26 : string "                                        "
telafimLinha27 : string "                                        "
telafimLinha28 : string "                                        "
telafimLinha29 : string "                                        "

;********************************************************
;                   TELA XUPA FEDERAL
;********************************************************

printtelaXUPAFEDERALScreen:

push r0
push r1
push r2
push r3
push r4
push r5
push r6
	
loadn r0,#40 
loadn r4,#40
loadn r5,#0
loadn r2,#telaXUPAFEDERALLinha29
add r2,r2,r0
loadn r0,#0
loadn r1,#telaXUPAFEDERALLinha0

   printtelaXUPAFEDERAL_Loop:
   	loadi r6,r1
	outchar r6, r0
	inc r1
	inc r0
	mod r3,r0,r4
	cmp r3,r5
	jne printtelaXUPAFEDERAL_skip
	inc r1
	printtelaXUPAFEDERAL_skip:
		cmp r1,r2
		jne printtelaXUPAFEDERAL_Loop

pop r6
pop r5
pop r4
pop r3
pop r2
pop r1	
pop r0
rts	

;declara uma tela para ser a tela após o fim do jogo dizendo XUPA FEDERAL!!!

telaXUPAFEDERALLinha0  : string "                                        "
telaXUPAFEDERALLinha1  : string "  X     X  U     U  PPPPPPPP      A     "
telaXUPAFEDERALLinha2  : string "   X   X   U     U  P       P    A A    "
telaXUPAFEDERALLinha3  : string "    X X    U     U  P       P   A   A   "
telaXUPAFEDERALLinha4  : string "     X     U     U  PPPPPPPP   AAAAAAA  "
telaXUPAFEDERALLinha5  : string "    X X    U     U  P          A     A  "
telaXUPAFEDERALLinha6  : string "   X   X   U     U  P          A     A  "
telaXUPAFEDERALLinha7  : string "  X     X   UUUUU   P          A     A  "
telaXUPAFEDERALLinha8  : string "                                        "
telaXUPAFEDERALLinha9  : string " FFFF EEEE DDDD   EEEE RRRR    A   L    "
telaXUPAFEDERALLinha10 : string " F    E    D   D  E    R   R  A A  L    "
telaXUPAFEDERALLinha11 : string " F    E    D    D E    R   R A   A L    "
telaXUPAFEDERALLinha12 : string " FFF  EEEE D    D EEEE RRRR  AAAAA L    "
telaXUPAFEDERALLinha13 : string " F    E    D    D E    R  R  A   A L    "
telaXUPAFEDERALLinha14 : string " F    E    D   D  E    R   R A   A L    "
telaXUPAFEDERALLinha15 : string " F    EEEE DDDD   EEEE R   R A   A LLLL "
telaXUPAFEDERALLinha16 : string "                                        "
telaXUPAFEDERALLinha17 : string "                                        "
telaXUPAFEDERALLinha18 : string "                                        "
telaXUPAFEDERALLinha19 : string "                                        "
telaXUPAFEDERALLinha20 : string " saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac "
telaXUPAFEDERALLinha21 : string " b CLIQUE 'M' PARA VOLTAR PARA O MENU b "
telaXUPAFEDERALLinha22 : string " daaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaai "
telaXUPAFEDERALLinha23 : string "                   op                   "
telaXUPAFEDERALLinha24 : string "                                        "
telaXUPAFEDERALLinha25 : string "                                        "
telaXUPAFEDERALLinha26 : string "                                        "
telaXUPAFEDERALLinha27 : string "                                        "
telaXUPAFEDERALLinha28 : string "                                        "
telaXUPAFEDERALLinha29 : string "                                        "
