
posCarro: var #1		;   Contém a posição atual da Carro
posAntCarro: var #1		;   Contém a posição anterior do Carro

posBot1: var #1
posAntBot1: var #1

posBot2: var #1
posAntBot2: var #1

posBot3: var #1
posAntBot3: var #1

posBot4: var #1
posAntBot4: var #1

Letra: var #1	        	;   Contém a letra que foi digitada pelo usuário
score: var #1

menu:
	call printtelamenuScreen	;   Chama a tela de menu do jogo
	
	menu_loop:			;   Entramos em um loop aguardando o usuário digitar S
		call DigLetra
		loadn r0, #'s'
		load r1, Letra
		cmp r0, r1		
		jeq main		;   Se o usuário digita S, vai para a função main do jogo
		jne menu_loop           ;   Se o usuário não digita S, volta pro loop (aguardando digitar
	
	halt


main:

call ApagaTela
call printtelaCenScreen

loadn r0,#12
store posBot1,r0

loadn r0,#22
store posAntBot1,r0

loadn r0,#22
store posBot2,r0

loadn r0,#12
store posAntBot2,r0

loadn r0,#12
store posBot3,r0

loadn r0,#22
store posAntBot3,r0

loadn r0,#22
store posBot4,r0

loadn r0,#12
store posAntBot4,r0

loadn r0,#1			;   Carrega 1 no R0

Loadn R0, #1052	
store posCarro, R0		;   Zera a posição atual do carro

loadn r0, #1061
store posAntCarro, R0		;   Zera a posição anterior do carro

loadn R0, #0			;   Contador para os mods = 0
loadn R2, #0			;   Para verificar se (mod(c/10)) = 0 e contador para o movebot1, movebot2 e movebot3
loadn r3, #0			;	contador para um loop de repetição do movimento dos bots
loadn r4, #200
loadn r5, #1060			;	comparador para o loop de repetição do movimento dos bots
loadn r6, #650
loadn r7, #400

store score,r0


Loop:
		loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveCarro	; Chama Rotina de movimentacao da Carro
		cmp r1,r2
		ceq MoveBot1
		cmp r1,r2
		jeq movebot2_permissao_concedida
		movebot2_permissao_concedida_fim:

		cmp r1,r2
		jeq movebot3_permissao_concedida
		movebot3_permissao_concedida_fim:

		cmp r1,r2
		jeq movebot4_permissao_concedida
		movebot4_permissao_concedida_fim:

		call Verifica_Colisao_Bot1
		call Verifica_Colisao_Bot2
		call Verifica_Colisao_Bot3
		call Verifica_Colisao_Bot4

		call Delay
		inc R0 	;c++
		inc r3
		cmp r3,r5
		jeq repeticao_de_movimento

		repeticao_de_movimento_fim:

		jmp Loop

		movebot2_permissao_concedida:


		cmp r0,r4
		cgr MoveBot2
		jmp movebot2_permissao_concedida_fim

		movebot3_permissao_concedida:

		cmp r0,r7
		cgr MoveBot3
		jmp movebot3_permissao_concedida_fim

		movebot4_permissao_concedida:
		cmp r0,r6
		cgr MoveBot4
		jmp movebot4_permissao_concedida_fim

		repeticao_de_movimento:
		loadn r0,#12
		store posBot1,r0

		loadn r0,#22
		store posAntBot1,r0

		loadn r0,#22
		store posBot2,r0

		loadn r0,#12
		store posAntBot2,r0

		loadn r0,#12
		store posBot3,r0

		loadn r0,#22
		store posAntBot3,r0

		loadn r0,#22
		store posBot4,r0

		loadn r0,#12
		store posAntBot4,r0

		loadn r0,#1			;   Carrega 1 no R0

		Loadn R0, #1052	
		store posCarro, R0		;   Zera a posição atual do carro

		loadn r0, #1061
		store posAntCarro, R0		;   Zera a posição anterior do carro

		loadn R0, #0			;   Contador para os mods = 0
		loadn R2, #0			;   Para verificar se (mod(c/10)) = 0 e contador para o movebot1, movebot2 e movebot3
		loadn r3, #0			;	contador para um loop de repetição do movimento dos bots
		loadn r4, #200
		loadn r5, #1060			;	comparador para o loop de repetição do movimento dos bots
		loadn r6, #650
		loadn r7, #400

		jmp repeticao_de_movimento_fim

	tela_fim:
	call printtelafimScreen

	loop_fim:
		call DigLetra
		loadn r0, #'s'
		load r1, Letra
		cmp r0, r1		
		jeq main
		loadn r2,#'n'
		cmp r2,r1
		jeq finalizando
	jmp loop_fim

	finalizando:
	call printtelaXUPAFEDERALScreen
	call DigLetra
	loadn r0, #'m'
	load r1, Letra
	cmp r0, r1		
	jeq menu
	jmp finalizando

Verifica_Colisao_Bot1:
	push r4
	push r5
	push r6
	push r7

		load r5,posCarro
		load r6,posBot1
		cmp r5,r6
		jeq tela_fim
		loadn r7,#40
		load r4,posCarro
		add r4,r4,r7
		add r4,r4,r7
		add r4,r4,r7    ;r4 agora armazena a posCarro na última linha da tela para a
		cmp r4,r6       ;verificação de batida ao mover o carro ( comparação com a primeira linha da posBot1 aqui)
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot1 ( nona linha de cima para baixo ) 
		jeq tela_fim
		cmp r4,r6       ;comparando a posCarro ( última linha ) com a posBot1 ( nona linha de cima para baixo )
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot1 ( oitava linha de cima para baixo )
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim

		pop r7
		pop r6
		pop r5
		pop r4
		rts


Verifica_Colisao_Bot2:
	push r4
	push r5
	push r6
	push r7

		load r5,posCarro
		load r6,posBot2
		cmp r5,r6
		jeq tela_fim
		loadn r7,#40
		load r4,posCarro
		add r4,r4,r7
		add r4,r4,r7
		add r4,r4,r7    ;r4 agora armazena a posCarro na última linha da tela para a
		cmp r4,r6       ;verificação de batida ao mover o carro ( comparação com a primeira linha da posBot2 aqui)
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot2 ( nona linha de cima para baixo ) 
		jeq tela_fim
		cmp r4,r6       ;comparando a posCarro ( última linha ) com a posBot2 ( nona linha de cima para baixo )
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot2 ( oitava linha de cima para baixo )
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim

		pop r7
		pop r6
		pop r5
		pop r4
		rts

Verifica_Colisao_Bot3:
	push r4
	push r5
	push r6
	push r7

		load r5,posCarro
		load r6,posBot3
		cmp r5,r6
		jeq tela_fim
		loadn r7,#40
		load r4,posCarro
		add r4,r4,r7
		add r4,r4,r7
		add r4,r4,r7    ;r4 agora armazena a posCarro na última linha da tela para a
		cmp r4,r6       ;verificação de batida ao mover o carro ( comparação com a primeira linha da posBot3 aqui)
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot3 ( nona linha de cima para baixo ) 
		jeq tela_fim
		cmp r4,r6       ;comparando a posCarro ( última linha ) com a posBot3 ( nona linha de cima para baixo )
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot3 ( oitava linha de cima para baixo )
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim

		pop r7
		pop r6
		pop r5
		pop r4
		rts

	Verifica_Colisao_Bot4:
	push r4
	push r5
	push r6
	push r7

		load r5,posCarro
		load r6,posBot4
		cmp r5,r6
		jeq tela_fim
		loadn r7,#40
		load r4,posCarro
		add r4,r4,r7
		add r4,r4,r7
		add r4,r4,r7    ;r4 agora armazena a posCarro na última linha da tela para a
		cmp r4,r6       ;verificação de batida ao mover o carro ( comparação com a primeira linha da posBot4 aqui)
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot4 ( nona linha de cima para baixo ) 
		jeq tela_fim
		cmp r4,r6       ;comparando a posCarro ( última linha ) com a posBot4 ( nona linha de cima para baixo )
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6       ;comparando a posCarro com a posBot4 ( oitava linha de cima para baixo )
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim
		sub r6,r6,r7
		cmp r5,r6
		jeq tela_fim
		cmp r4,r6
		jeq tela_fim

		pop r7
		pop r6
		pop r5
		pop r4
		rts

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

;--------------------------------
	
MoveCarro_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5

	load R0, posAntCarro	
	
	loadn r2,#' '
	outchar r2,r0
	loadn r3,#1
	add r0,r0,r3
	outchar R2, R0	
	loadn r3,#1
	add r0,r0,r3
	outchar R2, R0
	loadn r3,#1
	add r0,r0,r3
	outchar R2, R0	
	loadn r3,#1
	add r0,r0,r3
	outchar R2, R0	
	loadn r3,#1
	add r0,r0,r3
	outchar R2, R0	
	loadn r3,#1
	add r0,r0,r3
	outchar R2, R0

	load r0, posAntCarro

	loadn r3, #40
	add r0,r0,r3
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0

	load r0, posAntCarro

	loadn r3, #80
	add r0,r0,r3
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0

	load r0, posAntCarro

	loadn r3, #120
	add r0,r0,r3
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	
	load r0, posAntCarro

	loadn r3, #160
	add r0,r0,r3
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0
	outchar R2, R0
	inc r0

	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
MoveCarro_RecalculaPos:		; Recalcula posicao da Carro em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3

	load R0, posCarro
	
	inchar R1				; Le Teclado para controlar a Carro
	loadn R2, #'a'
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_A
	
	loadn R2, #'d'
	cmp R1, R2
	jeq MoveCarro_RecalculaPos_D

	
  MoveCarro_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posCarro, R0
	pop R3
	pop R2
	pop R1
	pop R0
	rts

  MoveCarro_RecalculaPos_A: ; Move Carro para Esquerda
    loadn R1, #40
    loadn R2, #12
	load r3,posCarro
    mod R1, r3, R1      ; Testa condicoes de Contorno
    cmp R1, R2
    jeq MoveCarro_RecalculaPos_Fim
    loadn r0,#1052
	store posAntCarro,r3
	store posCarro,r0
    jmp MoveCarro_RecalculaPos_Fim
       
  MoveCarro_RecalculaPos_D: ; Move Carro para Direita  
    loadn R1, #40
    loadn R2, #22
	load r3,posCarro
    mod R1, R3, R1      ; Testa condicoes de Contorno
    cmp R1, R2
    jeq MoveCarro_RecalculaPos_Fim
	loadn r0,#1062
	store posAntCarro,r3
	store posCarro,r0
    jmp MoveCarro_RecalculaPos_Fim
	

;----------------------------------

MoveCarro_Desenha:	; Desenha caractere da Carro
	push R0
	push R1
	push r2
	push r3

	loadn r3,#5
	Loadn R1, #'c'	; Carro
	load R0, posCarro
	outchar R1, R0
	store posAntCarro, R0	; Atualiza Posicao Anterior da Carro = Posicao Atual
	add r0,r0,r3
	outchar r1,r0

	loadn r3,#1
	Loadn R1, #'!'	; Carro
	load R0, posCarro
	add r0,r0,r3
	outchar R1, R0
	loadn r3,#5
	add r0,r0,r3
	outchar r1,r0

	load r0,posCarro
	inc r0
	inc r0
	loadn r1,#'$'
	outchar r1,r0
	inc r0
	loadn r1,#'#'
	outchar r1,r0
	inc r0
	loadn r1,#'$'
	outchar r1,r0

	load r0,posCarro
	loadn r2,#40
	loadn r1,#'@'
	add r0,r0,r2
	outchar r1,r0
	loadn r3,#5
	add r0,r0,r3
	outchar r1,r0

	load r0,posCarro
	loadn r2,#41
	loadn r1,#'a'
	add r0,r0,r2
	outchar r1,r0
	loadn r3,#5
	add r0,r0,r3
	outchar r1,r0

	load r0,posCarro
	loadn r2,#81
	loadn r1,#'"'
	add r0,r0,r2
	outchar r1,r0
	loadn r3,#40
	add r0,r0,r3
	outchar r1,r0
	loadn r3,#40
	add r0,r0,r3
	outchar r1,r0

	load r0,posCarro
	loadn r2,#85
	loadn r1,#'"'
	add r0,r2,r0
	outchar r1,r0
	loadn r3,#40
	add r0,r0,r3
	outchar r1,r0
	loadn r3,#40
	add r0,r0,r3
	outchar r1,r0
	

	pop r3
	pop r2
	pop R1
	pop R0
	rts

	Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	push r2
	
	load r2,score
	Loadn R1, #2000  ; a
	sub r1,r1,r2

   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #150 ; b
	
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	pop r2
	Pop R1
	Pop R0
	
	RTS		

	;*****************************************************************
	;                          MOVE BOT 1
	;*****************************************************************
	MoveBot1:
	push r0
	push r1

	call MoveBot1_Apaga
	call MoveBot1_Desenha		;}
	call MoveBot1_RecalculaPos		; Recalcula Posicao da Bot1
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveBot1_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	
	load R0, posAntBot1	
	loadn r2,#40
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	loadn r1,#' '
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0


	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------	
	
MoveBot1_RecalculaPos:	
	push R0
	push R1
	push R2
	push R3

	load r0,posBot1
	loadn r1,#40
	store posAntBot1,r0
	add r0,r0,r1
	store posBot1, R0
	loadn r1,#1052
	cmp r0,r1
	jle MoveBot1_RecalculaPos_skip

	load r1,score
	inc r1
	store score,r1

	MoveBot1_RecalculaPos_skip:

	pop R3
	pop R2
	pop R1
	pop R0
	rts
	

;----------------------------------

MoveBot1_Desenha:	; Desenha caractere da Bot1
	push R0
	push R1
	push r2
	push r3
	push r4

	loadn r0,#12
	load r1,posBot1
	cmp r0,r1
	jeq MoveBot1_Desenha_1linha
	loadn r2,#40
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_2linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_3linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_4linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_5linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_6linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_7linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_8linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot1_Desenha_9linha

	

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r1,#'c'
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'c'
	inc r0
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	

	finaliza_desenho_bot1:

	pop r4
	pop r3
	pop r2
	pop R1
	pop R0
	rts


	MoveBot1_Desenha_1linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0



jmp finaliza_desenho_bot1

MoveBot1_Desenha_2linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0



jmp finaliza_desenho_bot1

MoveBot1_Desenha_3linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0


jmp finaliza_desenho_bot1

MoveBot1_Desenha_4linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot1

MoveBot1_Desenha_5linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot1

MoveBot1_Desenha_6linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot1

MoveBot1_Desenha_7linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	

jmp finaliza_desenho_bot1

MoveBot1_Desenha_8linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot1

MoveBot1_Desenha_9linha:

	load r0,posBot1
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot1
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot1
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot1


;*****************************************************************
	;                          MOVE BOT 2
	;*****************************************************************
	MoveBot2:
	push r0
	push r1

	call MoveBot2_Apaga
	call MoveBot2_Desenha		;}
	call MoveBot2_RecalculaPos		; Recalcula Posicao da Bot2
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveBot2_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	
	load R0, posAntBot2	
	loadn r2,#40
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	loadn r1,#' '
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0


	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------	
	
MoveBot2_RecalculaPos:	
	push R0
	push R1
	push R2
	push R3

	load r0,posBot2
	loadn r1,#40
	store posAntBot2,r0
	add r0,r0,r1
	store posBot2, R0
	loadn r1,#1052
	cmp r0,r1
	jle MoveBot2_RecalculaPos_skip

	load r1,score
	inc r1
	store score,r1

	MoveBot2_RecalculaPos_skip:

	pop R3
	pop R2
	pop R1
	pop R0
	rts
	

;----------------------------------

MoveBot2_Desenha:	; Desenha caractere da Bot2
	push R0
	push R1
	push r2
	push r3
	push r4

	loadn r0,#12
	load r1,posBot2
	cmp r0,r1
	jeq MoveBot2_Desenha_1linha
	loadn r2,#40
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_2linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_3linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_4linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_5linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_6linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_7linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_8linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot2_Desenha_9linha

	

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r1,#'c'
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'c'
	inc r0
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	

	finaliza_desenho_bot2:

	pop r4
	pop r3
	pop r2
	pop R1
	pop R0
	rts


	MoveBot2_Desenha_1linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0



jmp finaliza_desenho_bot2

MoveBot2_Desenha_2linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0



jmp finaliza_desenho_bot2

MoveBot2_Desenha_3linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0


jmp finaliza_desenho_bot2

MoveBot2_Desenha_4linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot2

MoveBot2_Desenha_5linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot2

MoveBot2_Desenha_6linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot2

MoveBot2_Desenha_7linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	

jmp finaliza_desenho_bot2

MoveBot2_Desenha_8linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot2

MoveBot2_Desenha_9linha:

	load r0,posBot2
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot2
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot2
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

jmp finaliza_desenho_bot2

	;*****************************************************************
	;                          MOVE BOT 3
	;*****************************************************************
	MoveBot3:
	push r0
	push r1

	call MoveBot3_Apaga
	call MoveBot3_Desenha		;}
	call MoveBot3_RecalculaPos		; Recalcula Posicao da Bot3
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveBot3_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	
	load R0, posAntBot3	
	loadn r2,#40
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	loadn r1,#' '
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0


	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------	
	
MoveBot3_RecalculaPos:	
	push R0
	push R1
	push R2
	push R3

	load r0,posBot3
	loadn r1,#40
	store posAntBot3,r0
	add r0,r0,r1
	store posBot3, R0
	loadn r1,#1052
	cmp r0,r1
	jle MoveBot3_RecalculaPos_skip

	load r1,score
	inc r1
	store score,r1

	MoveBot3_RecalculaPos_skip:

	pop R3
	pop R2
	pop R1
	pop R0
	rts
	

;----------------------------------

MoveBot3_Desenha:	; Desenha caractere da Bot3
	push R0
	push R1
	push r2
	push r3
	push r4

	loadn r0,#12
	load r1,posBot3
	cmp r0,r1
	jeq MoveBot3_Desenha_1linha
	loadn r2,#40
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_2linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_3linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_4linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_5linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_6linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_7linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_8linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot3_Desenha_9linha

	

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r1,#'c'
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'c'
	inc r0
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	

	finaliza_desenho_Bot3:

	pop r4
	pop r3
	pop r2
	pop R1
	pop R0
	rts


	MoveBot3_Desenha_1linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0



jmp finaliza_desenho_Bot3

MoveBot3_Desenha_2linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0



jmp finaliza_desenho_Bot3

MoveBot3_Desenha_3linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0


jmp finaliza_desenho_Bot3

MoveBot3_Desenha_4linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot3

MoveBot3_Desenha_5linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot3

MoveBot3_Desenha_6linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot3

MoveBot3_Desenha_7linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	

jmp finaliza_desenho_Bot3

MoveBot3_Desenha_8linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot3

MoveBot3_Desenha_9linha:

	load r0,posBot3
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot3
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot3
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot3

	;*****************************************************************
	;                          MOVE BOT 4
	;*****************************************************************
	MoveBot4:
	push r0
	push r1

	call MoveBot4_Apaga
	call MoveBot4_Desenha		;}
	call MoveBot4_RecalculaPos		; Recalcula Posicao da Bot4
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveBot4_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5
	
	load R0, posAntBot4	
	loadn r2,#40
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	sub r0,r0,r2
	loadn r1,#' '
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0
	inc r0
	outchar r1,r0


	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------	
	
MoveBot4_RecalculaPos:	
	push R0
	push R1
	push R2
	push R3

	load r0,posBot4
	loadn r1,#40
	store posAntBot4,r0
	add r0,r0,r1
	store posBot4, R0
	loadn r1,#1052
	cmp r0,r1
	jle MoveBot4_RecalculaPos_skip

	load r1,score
	inc r1
	store score,r1

	MoveBot4_RecalculaPos_skip:

	pop R3
	pop R2
	pop R1
	pop R0
	rts
	

;----------------------------------

MoveBot4_Desenha:	; Desenha caractere da Bot4
	push R0
	push R1
	push r2
	push r3
	push r4

	loadn r0,#12
	load r1,posBot4
	cmp r0,r1
	jeq MoveBot4_Desenha_1linha
	loadn r2,#40
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_2linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_3linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_4linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_5linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_6linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_7linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_8linha
	add r0,r0,r2
	cmp r1,r0
	jeq MoveBot4_Desenha_9linha

	

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r1,#'c'
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'#'
	inc r0
	outchar r1,r0
	loadn r1,#'c'
	inc r0
	outchar r1,r0
	loadn r1,#'!'
	inc r0
	outchar r1,r0
	

	finaliza_desenho_Bot4:

	pop r4
	pop r3
	pop r2
	pop R1
	pop R0
	rts


	MoveBot4_Desenha_1linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0



jmp finaliza_desenho_Bot4

MoveBot4_Desenha_2linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0



jmp finaliza_desenho_Bot4

MoveBot4_Desenha_3linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0


jmp finaliza_desenho_Bot4

MoveBot4_Desenha_4linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot4

MoveBot4_Desenha_5linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot4

MoveBot4_Desenha_6linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot4

MoveBot4_Desenha_7linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	

jmp finaliza_desenho_Bot4

MoveBot4_Desenha_8linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot4

MoveBot4_Desenha_9linha:

	load r0,posBot4
	loadn r1,#'@'
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'a'
	loadn r2,#1
	add r0,r2,r0
	outchar r1,r0
	loadn r2,#5
	add r0,r0,r2
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'b'
	inc r0
	inc r0
	outchar r1,r0
	inc r0
	inc r0
	outchar r1,r0 

	load r0,posBot4
	loadn r1,#'#'
	inc r0
	inc r0
	inc r0
	outchar r1,r0

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	inc r1
	loadn r3,#'!'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r1,r0,r1
	loadn r3,#'c'
	outchar r3,r1
	inc r1
	inc r1
	inc r1
	inc r1
	inc r1
	outchar r3,r1

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	loadn r3,#' '
	inc r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#' '
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'"'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0

	load r0,posBot4
	loadn r1,#40
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	sub r0,r0,r1
	loadn r3,#'@'
	outchar r3,r0
	inc r0
	loadn r3,#'a'
	outchar r3,r0
	loadn r3,#' '
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	outchar r3,r0
	inc r0
	loadn r3,#'@'
	outchar r3,r0
	loadn r3,#'a'
	inc r0
	outchar r3,r0

jmp finaliza_desenho_Bot4

;-------------------------------------------------------------

;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	push r2
	push r3

	loadn r1, #'s'
	loadn r2,#'n'
	loadn r3,#'m'

   DigLetra_Loop:
		inchar r0			; Le o teclado
		cmp r0, r1
		jeq Letra_S			; compara r0 com o código da tabela ASCII de S
		cmp r0,r2
		jeq Letra_N
		cmp r0,r3
		jeq Letra_M
		jne DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	Letra_S:
	store Letra, r0
	jmp DigLetra_fim

	Letra_N:
	store Letra, r0			; Salva a tecla na variavel global "Letra"
	jmp DigLetra_fim

	Letra_M:
	store Letra,r0
	jmp DigLetra_fim

	DigLetra_fim:

	pop r3
	pop r2
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
;                       APAGA TELA
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
; Declara uma tela vazia para ser preenchida em tempo de execussao:

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

	loadn r0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn r3, #40  	; Incremento da posicao da tela!
	loadn r4, #41  	; incremento do ponteiro das linhas da tela
	loadn r5, #1200 ; Limite da tela!
	
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
telamenuLinha10 : string "      c...........................!     "
telamenuLinha11 : string "      :   CLIQUE  S  PARA JOGAR   ;     "
telamenuLinha12 : string "      @///////////////////////////a     "
telamenuLinha13 : string "                                        "
telamenuLinha14 : string "                  klmn                  "
telamenuLinha15 : string "                  opqr                  "
telamenuLinha16 : string "                  stuv                  "
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
;                   IMPRIME CENÁRIO
;********************************************************
	
printtelaCenScreen:

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
loadn r2,#telaCenLinha29
add r2,r2,r0
loadn r0,#0
loadn r1,#telaCenLinha0

   printtelaCen_Loop:
   	loadi r6,r1
	outchar r6, r0
	inc r1
	inc r0
	mod r3,r0,r4
	cmp r3,r5
	jne printtelaCen_skip
	inc r1
	printtelaCen_skip:
		cmp r1,r2
		jne printtelaCen_Loop

pop r6
pop r5
pop r4
pop r3
pop r2
pop r1	
pop r0
rts	

; Declara uma tela vazia para ser preenchida em tempo de execussao:

telaCenLinha0  : string " %        *         )         *   '+(   "
telaCenLinha1  : string "          *                   *   g,h   "
telaCenLinha2  : string "      %   *         )         *    &    "
telaCenLinha3  : string "          *                   *    &    "
telaCenLinha4  : string " %        *         )         *    &    " 
telaCenLinha5  : string "   '+(    *                   *  %      "
telaCenLinha6  : string "   g,h    *         )         *       % "
telaCenLinha7  : string "    &     *                   *         "
telaCenLinha8  : string "    &     *         )         *  %      "
telaCenLinha9  : string "    &     *                   *         "
telaCenLinha10 : string " %        *         )         *   '+(   "
telaCenLinha11 : string "          *                   *   g,h   "
telaCenLinha12 : string "       %  *         )         *    &    "
telaCenLinha13 : string "          *                   *    &    "
telaCenLinha14 : string " %        *         )         *    &    "
telaCenLinha15 : string "   '+(    *                   * %       "
telaCenLinha16 : string "   g,h    *         )         *         "
telaCenLinha17 : string "    &     *                   *      %  "
telaCenLinha18 : string "    &     *         )         *         "
telaCenLinha19 : string "    &     *                   * %       "
telaCenLinha20 : string "          *         )         *   '+(   "
telaCenLinha21 : string " %        *                   *   g,h   "
telaCenLinha22 : string "          *         )         *    &    "
telaCenLinha23 : string "       %  *                   *    &    "
telaCenLinha24 : string " %        *         )         *    &    "
telaCenLinha25 : string "   '+(    *                   *         "
telaCenLinha26 : string "   g,h    *         )         * %       "
telaCenLinha27 : string "    &     *                   *         "
telaCenLinha28 : string "    &     *         )         *      %  "
telaCenLinha29 : string "    &     *                   *         "



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
telafimLinha9  : string "   c.................................!  "
telafimLinha10 : string "   :          VOCE MORREU            ;  "
telafimLinha11 : string "   :                                 ;  "
telafimLinha12 : string "   : CLIQUE  S  PARA JOGAR NOVAMENTE ;  "
telafimLinha13 : string "   :                                 ;  "
telafimLinha14 : string "   : OU  N  PARA VOLTAR PARA O MENU  ;  "
telafimLinha15 : string "   @/////////////////////////////////a  "
telafimLinha16 : string "                                        "
telafimLinha17 : string "                                        "
telafimLinha18 : string "                  klmn                  "
telafimLinha19 : string "                  opqr                  "
telafimLinha20 : string "                  stuv                  "
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
telaXUPAFEDERALLinha20 : string " c....................................! "
telaXUPAFEDERALLinha21 : string " : CLIQUE  M  PARA VOLTAR PARA O MENU ; "
telaXUPAFEDERALLinha22 : string " @////////////////////////////////////a "
telaXUPAFEDERALLinha23 : string "                                        "
telaXUPAFEDERALLinha24 : string "                  klmn                  "
telaXUPAFEDERALLinha25 : string "                  opqr                  "
telaXUPAFEDERALLinha26 : string "                  stuv                  "
telaXUPAFEDERALLinha27 : string "                                        "
telaXUPAFEDERALLinha28 : string "                                        "
telaXUPAFEDERALLinha29 : string "                                        "
