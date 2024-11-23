jmp menu



Msn1: string "DESEJA JOGAR NOVAMENTE? 'S/N'"
Msn2: string "FIM DE JOGO"
Msn3: string "DIGITE 'S' PARA INICIAR"

Letra: var #1		; Contem a letra que foi digitada

posCarro: var #1			; Contem a posicao atual da Carro
posAntCarro: var #1		; Contem a posicao anterior da Carro


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
	call ImprimeTela   		;  Rotina de Impresao de Cenario na Tela Inteira
	call MoveCarro_Desenha
	call Delay
	call MoveCarro_RecalculaPos
	call MoveCarro_Apaga
	jnz main

halt
;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #50  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #3000	; b
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return

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
	

MoveCarro_Multi:
	push r0
	push r1
	
	call MoveCarro_RecalculaPos_Multi		; Recalcula Posicao da Carro

; So' Apaga e Redesenha se (pos != posAnt)
;	If (posCarro != posAntCarro)	{	
	load r0, posCarro
	load r1, posAntCarro
	cmp r0, r1
	jeq MoveCarro_Multi_Skip
		call MoveCarro_Apaga
		call MoveCarro_Desenha		;}
		
	MoveCarro_Multi_Skip:
			
		
		pop r1
		pop r0
		rts
	
;------------------------------

	
MoveCarro_RecalculaPos:		; Recalcula posicao da Carro em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	push R6

	load R0, posCarro

	
	loadn R2, #'d'
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_D
		
	loadn R2, #'s'
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_S
	

MoveCarro_RecalculaPos_S:	; Move Carro para Baixo
    call MoveCarro_Apaga
    loadn r5, #2
    loadn R1, #12	; Carro
	loadn R2, #2048
	add R1, R1, R2
	load R0, posCarro
	outchar R1, R0
    jmp MoveCarro_RecalculaPos_Fim


MoveCarro_RecalculaPos_S_Multi:	; Move Carro para Baixo
	loadn R1, #1159
	cmp R0, R1		; Testa condicoes de Contorno 
	jgr MoveCarro_RecalculaPos_Fim_Multi
	loadn R1, #40
	add R0, R0, R1	; pos = pos + 40
	jmp MoveCarro_RecalculaPos_Fim_Multi


  MoveCarro_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posCarro, R0
	
	pop R6
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

  MoveCarro_RecalculaPos_A:	; Move Carro para Esquerda
  	
  	call MoveCarro_Apaga
  	loadn r5, #3

  	loadn R1, #11	; Carro
	loadn R2, #2048
	add R1, R1, R2
	load R0, posCarro
	outchar R1, R0
	
  	
  	jmp MoveCarro_RecalculaPos_Fim
  	
	loadn R1, #40
	loadn R2, #0
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_Fim
	dec R0	; pos = pos -1
	jmp MoveCarro_RecalculaPos_Fim
		
  MoveCarro_RecalculaPos_D:	; Move Carro para Direita
  
  	call MoveCarro_Apaga
  	loadn r5, #1
  	loadn R1, #10	; Carro
	loadn R2, #2048
	add R1, R1, R2
	load R0, posCarro
	outchar R1, R0
  	
	jmp MoveCarro_RecalculaPos_Fim
	
	
	loadn r3, #1
	cmp r2, r3
	jeq Mover_Dir
	
	
	loadn r3, #3
	cmp r2, r3
	jeq Mover_Esq
	
	
	Mover_Dir:
    loadn R2, #39
    mod R1, R0, R1    ; Testa condicoes de Contorno 
    cmp R1, R2
    jeq MoveCarro_RecalculaPos_Fim
		;inc R0
		;jmp MoveCarro_RecalculaPos_Fim
	Mover_Esq:
    loadn R2, #0
    mod R1, R0, R1    ; Testa condicoes de Contorno 
    cmp R1, R2
    jeq MoveCarro_RecalculaPos_Fim
		;dec R0
		;jmp MoveCarro_RecalculaPos_Fim
    
	loadn R1, #40
	loadn r3, #0
	cmp r3, r2
	jeq Mover_Sul_Zero
	
	loadn r3, #1
	cmp r3, r2
	jeq Mover_Sul_Um
	
	loadn r3, #2
	cmp r3, r2
	jeq Mover_Sul_Dois
	
	loadn r3, #3
	cmp r3, r2
	jeq Mover_Sul_Tres
	
	Mover_Sul_Zero:
    loadn R2, #1159
    cmp R0, R2    ; Testa condicoes de Contorno 
    jgr MoveCarro_RecalculaPos_Fim
		;add R0, R0, R1	; pos = pos + 40
		;jmp MoveCarro_RecalculaPos_Fim	
	
	Mover_Sul_Um:
    loadn R2, #0
    mod R1, R0, R1    ; Testa condicoes de Contorno 
    cmp R1, R2
    jeq MoveCarro_RecalculaPos_Fim
    
		;dec r0
		;jmp MoveCarro_RecalculaPos_Fim
	
	Mover_Sul_Dois:
    cmp R0, R1   ; Testa condicoes de Contorno 
    jle MoveCarro_RecalculaPos_Fim
		;sub r0, r0, r1
		;jmp MoveCarro_RecalculaPos_Fim
	
	Mover_Sul_Tres:
    loadn R2, #39
    mod R1, R0, R1    ; Testa condicoes de Contorno 
    cmp R1, R2
    jeq MoveCarro_RecalculaPos_Fim
    
		;inc r0
		;jmp MoveCarro_RecalculaPos_Fim

MoveCarro_Apaga:		; Apaga a Carro preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntCarro	; R0 = posAnt
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!

	loadn R1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

MoveCarro_RecalculaPos_Multi:		; Recalcula posicao da Carro em funcao das Teclas pressionadas
	push R0
	push R1
	push R2

	load R0, posCarro
	
	inchar R1				; Le Teclado para controlar a Carro
	loadn R2, #'a'
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_A_Multi
	
	loadn R2, #'d'
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_D_Multi
	
	
  MoveCarro_RecalculaPos_Fim_Multi:	; Se nao for nenhuma tecla valida, vai embora
	store posCarro, R0

	pop R2
	pop R1
	pop R0
	rts

MoveCarro_RecalculaPos_A_Multi:	; Move Carro para Esquerda
	loadn R1, #40
	loadn R2, #0
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_Fim_Multi
	dec R0	; pos = pos -1
	jmp MoveCarro_RecalculaPos_Fim_Multi

MoveCarro2_RecalculaPos_A_Multi:	; Move Carro para Esquerda
	loadn R1, #40
	loadn R2, #0
	mod R1, R4, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_Fim_Multi
	dec R4	; pos = pos -1
	jmp MoveCarro_RecalculaPos_Fim_Multi

;------------------
MoveCarro_RecalculaPos_D_Multi:	; Move Carro para Direita	
	loadn R1, #40
	loadn R2, #39
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_Fim_Multi
	inc R0	; pos = pos + 1
	jmp MoveCarro_RecalculaPos_Fim_Multi
	
MoveCarro2_RecalculaPos_D_Multi:	; Move Carro para Direita	
	loadn R1, #40
	loadn R2, #39
	mod R1, R4, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_Fim_Multi
	inc R4	; pos = pos + 1
	jmp MoveCarro_RecalculaPos_Fim_Multi

;------------------


MoveCarro_Desenha:	; Desenha caracter do Carro
	push R0
	push R1
	push R2
	push R3
	push R4
	
	loadn r4, #0
	cmp r3, r4
	jeq Desenhar_Zero
	
	loadn r4, #1
	cmp r3, r4
	jeq Desenhar_Um
	
	loadn r4, #2
	cmp r3, r4
	jeq Desenhar_Dois
	
	loadn r4, #3
	cmp r3, r4
	jeq Desenhar_Tres
	
	Desenhar_Zero:
		loadn R1, #8	; Carro
		jmp MoveCarro_Desenha_Fim
	Desenhar_Um:
		loadn R1, #10	; Carro
		jmp MoveCarro_Desenha_Fim
	Desenhar_Dois:
		loadn R1, #12	; Carro
		jmp MoveCarro_Desenha_Fim
	Desenhar_Tres:
		loadn R1, #11	; Carro
		jmp MoveCarro_Desenha_Fim
	
	MoveCarro_Desenha_Fim:
		loadn R2, #2048
		add R1, R1, R2
		load R0, posCarro
		outchar R1, R0
		store posAntCarro, R0	; Atualiza Posicao Anterior da Carro = Posicao Atual
		
		pop R4
		pop R3
		pop R2
		pop R1
		pop R0
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

telaCenLinha0  : string "          z                  z          "
telaCenLinha1  : string "          z                  z          "
telaCenLinha2  : string "          z                  z          "
telaCenLinha3  : string "          z                  z          "
telaCenLinha4  : string "          z                  z          "
telaCenLinha5  : string "          z                  z          "
telaCenLinha6  : string "          z                  z          "
telaCenLinha7  : string "          z                  z          "
telaCenLinha8  : string "          z                  z          "
telaCenLinha9  : string "          z                  z          "
telaCenLinha10 : string "          z                  z          "
telaCenLinha11 : string "          z                  z          "
telaCenLinha12 : string "          z                  z          "
telaCenLinha13 : string "          z                  z          "
telaCenLinha14 : string "          z                  z          "
telaCenLinha15 : string "          z                  z          "
telaCenLinha16 : string "          z                  z          "
telaCenLinha17 : string "          z                  z          "
telaCenLinha18 : string "          z                  z          "
telaCenLinha19 : string "          z                  z          "
telaCenLinha20 : string "          z                  z          "
telaCenLinha21 : string "          z                  z          "
telaCenLinha22 : string "          z                  z          "
telaCenLinha23 : string "          z                  z          "
telaCenLinha24 : string "          z                  z          "
telaCenLinha25 : string "          z                  z          "
telaCenLinha26 : string "          z                  z          "
telaCenLinha27 : string "          z                  z          "
telaCenLinha28 : string "          z                  z          "
telaCenLinha29 : string "          z                  z          "	



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
				
