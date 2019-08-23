;==============================================================  Pintar Estrella ===================================
PintarPremio macro buffer ;, xFinal , yPosition 
LOCAL PINTAR1,PINTAR2,PINTAR3, PINTAR4,FIN , MOVERPUNTERO , MOVERPUNTERO2, MOVERPUNTERO3,TRAN1, TRAN2, TRAN3
			;buffer = la direccion de memoria VRAM 
			;xFinal = posicion Final del cursos para pintar el cuadrado 	
			; f(x,y) = x + y*320
			mov es, buffer			    ;put segment address in es
			mov di, 9600			    ; 30 * 320 = 40000
		    add di, 50	      			; x = 50  
			mov cx, 8				    ; loop counter =  el ancho de pixeles pintados
			mov bx, 02h					; color amarillo para el carro
		
			PINTAR1:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 12218			; x = 50 ;  y = 38*320  -> Final 12860	del cuadro
				je  TRAN1
			loop PINTAR1
			
			MOVERPUNTERO:
			    add di, 312				; se suman los bordes del cuadro 50 + 274 = 290 
				mov cx, 8				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR1
;******************************************			
			TRAN1:
				add di,304
				mov cx,24
				jmp PINTAR2
			
			PINTAR2:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 14786			; x = 42 ;  y = 46*320  -> Final 16070	del cuadro
				je  TRAN2
			loop PINTAR2			
			
			MOVERPUNTERO2:
			    add di, 296				; se suman los bordes del cuadro 40 + 274 = 290 
				mov cx, 24				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR2
		
			; tercer bloque	
;******************************************************
			TRAN2:						; Transicion del tercer bloque 
				add di, 304
				mov cx, 8
				jmp PINTAR3			
			
			PINTAR3:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 17338			; x = 58 ;  y = 60*320  -> Final 19260	del cuadro
				je  TRAN3
			loop PINTAR3			
			
			MOVERPUNTERO3:
			    add di, 312				; se suman los bordes del cuadro 40 + 274 = 290 
				mov cx, 8				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR3

;============ Figura mas pequeña 
			TRAN3:
				xor di ,di 
				mov di, 12800			    ; 40 * 320 = 40000
				add di, 52	      			; x = 52  
				mov cx, 4				    ; loop counter =  el ancho de pixeles pintados
				mov bx, 0Ah					; color verde claro 
			
			PINTAR4:
				mov es:[di], bx			   ;set pixel to colour
				inc di					   ;move to next pixel
				cmp di , 14776			   ; x = 52 ;  y = 46*320  -> Final 12860	del cuadro
				je  FIN 
			loop PINTAR4
			
			MOVERPUNTERO4:
			    add di, 316				; se suman los bordes del cuadro 50 + 274 = 290 
				mov cx, 4				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR4					
		
			FIN	:	
endm

;=========================================================== Pintar Estrella Mala =====================
Pintar_Obstaculo macro  startaddr , estrella_X , estrella_Y, estrella1 ,estrella2
LOCAL repetir , repetir2 , repetir3 
				
				push ax
				push cx 
				push dx
				
				mov es, startaddr											;colocar direccion de segmento de video en ES
				;f(158,98) = x + y*320		
				mov ax ,  estrella_Y										;y*320 = 98*320 = 31360
				mov cx ,  320   
				mul cx 
				mov di , ax 
				add di ,  estrella_X										;sumar x
				mov dx ,     	   6										; contador de alto de los bloques  
				xor si , 		  si 
				mov cx , 		  15										;Ancho del bloque
				
				
				repetir:
				mov ax      , [estrella1+si]
				mov es:[di] ,  ax
				inc bx

				add si 		, 2;
				inc di	
				dec cx
				jnz repetir

				dec dx 
				xor si 		,  si 
				mov cx 		,  15										;tamaño del dato a mover
				add di 		, 305				
				cmp dx 		,   0		
				jg  repetir  
				
				
				mov dx ,     8										; contador de alto de los bloques  
				xor si , 	si 
				mov cx , 	15										;Ancho del bloque
				
				repetir2:
				mov ax      , [estrella2+si]
				mov es:[di] ,  ax
				inc bx

				add si 		, 2;
				inc di	
				dec cx
				jnz repetir2

				dec dx 
				xor si 		,  si 
				mov cx 		,  15										;tamaño del dato a mover
				add di 		, 305				
				cmp dx 		,   0		
				jg  repetir2  

				mov dx ,     6										; contador de alto de los bloques  
				xor si , 	si 
				mov cx , 	15										;Ancho del bloque
				
				repetir3:
				mov ax      , [estrella1+si]
				mov es:[di] ,  ax
				inc bx

				add si 		, 2;
				inc di	
				dec cx
				jnz repetir3

				dec dx 
				xor si 		,  si 
				mov cx 		,  15										;tamaño del dato a mover
				add di 		, 305				
				cmp dx 		,   0		
				jg  repetir3  

							 
				pop dx
				pop cx
				pop ax

endm 


;==============================================================  Pintar Estrella ===================================
PintarObstaculo macro buffer ;, xFinal , yPosition 
LOCAL PINTAR1,PINTAR2,PINTAR3, PINTAR4,FIN , MOVERPUNTERO , MOVERPUNTERO2, MOVERPUNTERO3, MOVERPUNTERO4, TRAN1, TRAN2, TRAN3
			;buffer = la direccion de memoria VRAM 
			;xFinal = posicion Final del cursos para pintar el cuadrado 	
			; f(x,y) = x + y*320
			mov es, buffer			    ;put segment address in es
			mov di, 9600			    ; 30 * 320 = 40000
		    add di, 50	      			; x = 50  
			mov cx, 8				    ; loop counter =  el ancho de pixeles pintados
			mov bx, 04h					; color amarillo para el carro
		
			PINTAR1:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 12218			; x = 50 ;  y = 38*320  -> Final 12860	del cuadro
				je  TRAN1
			loop PINTAR1
			
			MOVERPUNTERO:
			    add di, 312				; se suman los bordes del cuadro 50 + 274 = 290 
				mov cx, 8				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR1
;******************************************			
			TRAN1:
				add di,304
				mov cx,24
				jmp PINTAR2
			
			PINTAR2:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 14786			; x = 42 ;  y = 46*320  -> Final 16070	del cuadro
				je  TRAN2
			loop PINTAR2			
			
			MOVERPUNTERO2:
			    add di, 296				; se suman los bordes del cuadro 40 + 274 = 290 
				mov cx, 24				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR2
		
			; tercer bloque	
;******************************************************
			TRAN2:						; Transicion del tercer bloque 
				add di, 304
				mov cx, 8
				jmp PINTAR3			
			
			PINTAR3:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 17338			; x = 58 ;  y = 60*320  -> Final 19260	del cuadro
				je  TRAN3
			loop PINTAR3			
			
			MOVERPUNTERO3:
			    add di, 312				; se suman los bordes del cuadro 40 + 274 = 290 
				mov cx, 8				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR3

;============ Figura mas pequeña 
			TRAN3:
				xor di ,di 
				mov di, 12800			    ; 40 * 320 = 40000
				add di, 52	      			; x = 52  
				mov cx, 4				    ; loop counter =  el ancho de pixeles pintados
				mov bx, 0Ch					; color verde claro 
			
			PINTAR4:
				mov es:[di], bx			   ;set pixel to colour
				inc di					   ;move to next pixel
				cmp di , 14776			   ; x = 52 ;  y = 46*320  -> Final 12860	del cuadro
				je  FIN 
			loop PINTAR4
			
			MOVERPUNTERO4:
			    add di, 316				; se suman los bordes del cuadro 50 + 274 = 290 
				mov cx, 4				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR4					
		
			FIN	:	
endm




;------------------------------------------------------------- Pintar Carro	Moviendo--------------------	
PintarCarroMoviendo macro buffer , xFinal , yPosition , colorHexadecimal 
LOCAL PINTAR, FIN , MOVERPUNTERO
			;buffer = la direccion de memoria VRAM 
			;xFinal = posicion Final del cursos para pintar el cuadrado 	
			; f(x,y) = x + y*320
			mov es, buffer			    ;put segment address in es
			mov di, yPosition			; 125 * 320 = 40000
		    add di, 16	      			; x = 16  
			mov cx, 30				    ; loop counter =  el ancho de pixeles pintados
			mov bx, colorHexadecimal    ; color amarillo para el carro
		
			PINTAR:
				mov es:[di], bx			;set pixel to colour
				inc di					;move to next pixel
				cmp di , xFinal			; x = 46 ;  y = 183*320  -> Final 59246	del cuadro
				je  FIN
			loop PINTAR
			
			MOVERPUNTERO:
			    add di, 290				; se suman los bordes del cuadro 16 + 274 = 290 
				mov cx, 30				; loop counter = ancho del lo que se esta pintando en pixeles
				jmp PINTAR
			
			FIN	:	
endm

;======================================================================
    ; Esta funcion causa retardos 

Delay macro
	mov cx, 01h 		; tiempo del delay
	mov dx, 01h 		; tiempo del delay
	mov ah , 86h
	int 15h

endm 
;===================================================================== get keystrokes 


getTecla macro 
	mov ah , 00h
	int 16h
endm	


Delay2 macro
	MOV CX, 01h;01H ;time delay (copy pasted from stackoverflow) 
	MOV DX, 3021h;4240H 
	MOV AH, 86H 
	INT 15H

endm

;======================================================================

	;GetHora
	
GetTime macro 
	mov ah, 2Ch					; get the time system							
	int 21h						; CH = hour , CL = minute  , DH = segundos  , DL = 1/100 segundos

endm 	


;================================================================ Print Video Text in a specific place  

Print_VideoString macro cadena , pagina , fila  , columna

	  push      dx
      push      ax
      push      cx
      mov       ah, 2							; modo de escritura con el puntero en modo video 
      mov       bh, pagina						; numero de pagina 
      mov       dh, fila						; numero de fila 
      mov       dl, columna						; numero columna 
      int       10h								; ejecucion de la interrupcion 

      mov       dx, offset cadena				; tamañ de la cadena 
      mov       ax, dow
      mov       cl, 0ah
      mul       cl
      mov       ah, 00h
      add       ax, dx
      mov       dx, ax

      mov       ah, 09h
      int       21h

      pop       cx
      pop       ax
      pop       dx

endm 


;======================================================================
	; funcion Clean
	; limpia la memoria de video (llena de 0s o pixeles negros)

CleanVideo macro
LOCAL Refresh
	mov es, startaddr		    ;put segment address in es
	mov di, 0					;row 0
	add di, 0					;column 0
	mov cx, 64000				;loop counter
	mov ax, 0					;cannot do mem-mem copy so use reg

	Refresh:
		mov es:[di], ax			;set pixel to colour
		inc di					;move to next pixel
	loop Refresh

endm

;======================================================================
GetCh2 macro 
	mov ah,08h			; funcion 8, capturar caracter sin mostrarlo
	int 21h				; interrupcion DOS

endm


