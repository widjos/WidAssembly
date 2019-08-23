 

print macro cadena 
LOCAL ETIQUETA 
ETIQUETA: 
	MOV ah,09h 
	MOV dx,@data 
	MOV ds,dx 
	MOV dx, offset cadena 
	int 21h
endm

getRuta macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h
endm


contarCaracteres macro buffer, total, buffer2,limite
LOCAL INICIO,AVANZAR,CONTAR,FIN
	xor si,si
INICIO:
	cmp	buffer[si],10
	je	AVANZAR	
	cmp	buffer[si],32
	je	AVANZAR
	cmp	buffer[si],13
	je	AVANZAR
	cmp	si,limite
	je	FIN
	inc	total
	inc si
	jmp INICIO
AVANZAR:
	inc si
	jmp INICIO
FIN:
	numberToString	buffer2,total
	print buffer2
endm	

; -------------------------------------------- CLEAN BUFFER --------------------------------------------
cleanBuffer macro  buffer
LOCAL INICIO, AVANZAR ,   FIN 
	xor di , di
INICIO:
	cmp buffer[di] , 24h 	
    je  FIN
    mov buffer[di] , 0

AVANZAR:
    inc di
	jmp INICIO
FIN:
 
endm

appendBuffer macro buffer1 , buffer2  , bufferResultado					; MACRO Que une dos cadenas; con una coma de pormedio 
LOCAL INICIO, AVANZAR ,AVANZAR2, CADENA2 , NUEVACADENA , FIN
	xor si , si 
	xor di , di
	xor ax , ax
INICIO:
    mov al ,buffer1[di]
	cmp al , 24h	
    je  NUEVACADENA
	cmp al , 0
	je  NUEVACADENA	
	mov bufferResultado[si], al
    jmp AVANZAR

	
AVANZAR:
    inc si
    inc di
	jmp INICIO

AVANZAR2:
    inc si
	inc di
	jmp CADENA2

CADENA2 :
	mov ah , buffer2[di]
	cmp ah , 24h
	je  FIN
    cmp ah , 0
	je  FIN
    mov bufferResultado[si], ah  	
	jmp AVANZAR2
     	
NUEVACADENA:
    xor di , di
	mov bufferResultado[si], 2Ch	;Moviendo coma al buffer
	inc si  
	jmp CADENA2

FIN: 

	mov bufferResultado[si], 3Bh    ;Moviendo punto y coma en el buffer
	mov bufferResultado[si+1], 0Ah    ;Moviendo salto de linea solo por estetica el buffer
endm

IsAdmin macro   usuario , admin
LOCAL INICIO, AVANZAR, FIN
	xor si , si 
	xor di , di
	xor ax , ax
	mov dl , 48							; es verdadero dl 1
INICIO:
	mov al, usuario[si]
    mov ah, admin[di]
    cmp ah, 24h							; caracter de fin de linea 
    je  FIN  	
	cmp  al ,ah
	jne ERRORUSUARIO  
AVANZAR:
    inc si
    inc di    
    jmp INICIO
ERRORUSUARIO:
	mov dl, 49							; dl es  0 	
	jmp FIN
FIN:
   	
	
endm

VerificarUsuario macro bufferUsuarios , usuario, mensaje1 , mensaje2
LOCAL INICIO , AVANZAR ,FIN , ERRORUSUARIO , CORRECTO
	xor si , si 
	xor di , di
	xor ax , ax
	mov bl , 48                         ; Inicializo el valor de bl con 0 para decir que es falso 
INICIO:
	mov al, bufferUsuarios[si]
    mov ah, usuario[di] 	
	cmp  al ,ah
	jne ERRORUSUARIO  
AVANZAR:
    cmp al, 24h							; caracter de fin de linea 
    je  FIN 
    cmp ah, 3Bh
	je CORRECTO
    inc si
    inc di    
    jmp INICIO
ERRORUSUARIO:
    xor di , di
    mov al, bufferUsuarios[si]	
	inc si  
	cmp al , 3Bh  						  ; Espero a encontrar el salto de linea entre cada usuario en el archivo 							
   	je  ERRORUSUARIO
	cmp al , 13  						  ; Espero a encontrar el salto de linea entre cada usuario en el archivo 							
   	je  ERRORUSUARIO	
	cmp al ,  24h
	je  FIN
	cmp al ,  0Ah
	je  INICIO
    jmp ERRORUSUARIO

CORRECTO:
    mov bl, 49                      ; Bandera en bl es verdadera  = 1 	
			
FIN :


endm	
	
;------------------------------------------------------------- Pintar carretera	--------------------	
PintarCarretera macro buffer 
LOCAL PINTAR, FIN , MOVERPUNTERO
			; f(20,40) = x + y*320
			mov es, buffer			    ;put segment address in es
			mov di, 9600			    ; 30 * 320 = 9600
			add di, 15	      			; x = 15  
			mov cx, 290				    ; loop counter
			mov ax, 07h					; color gris claro pra el cuadro
		
			PINTAR:
				mov es:[di], ax			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 59185			;Final del cuadro	
				je  FIN
			loop PINTAR
			
			MOVERPUNTERO:
			    add di, 30				; se suman los bordes del cuadro 15 + 15 
				mov cx, 290				; se inicia el contador con 290 para realizar el loop
				jmp PINTAR
			
			FIN	:	
				
endm

;------------------------------------------------------------- Pintar Carro	--------------------	
PintarCarro macro buffer 
LOCAL PINTAR, FIN , MOVERPUNTERO
			;cuadro de 30 * 58    color amarillo 	
			; f(20,40) = x + y*320
			mov es, buffer			    ;put segment address in es
			mov di, 40000			    ; 125 * 320 = 40000
			add di, 16	      			; x = 16  
			mov cx, 30				    ; loop counter
			mov ax, 0Eh					; color amarillo para el carro
		
			PINTAR:
				mov es:[di], ax			;set pixel to colour
				inc di					;move to next pixel
				cmp di , 58606			; x = 46 ;  y = 183*320  -> Final 59246	del cuadro
				je  FIN
			loop PINTAR
			
			MOVERPUNTERO:
			    add di, 290				; se suman los bordes del cuadro 16 + 274 = 290 
				mov cx, 30				; se inicia el contador con 290 para realizar el loop
				jmp PINTAR
			
			FIN	:	
endm



numberToString MACRO buffer, number
LOCAL NEGATIVO, INICIO, NEXT, I0, FINAL
		PUSH DI
		PUSH SI
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		XOR DI, DI
		XOR SI, SI
		XOR DX, DX
		MOV AX, number
		MOV BX, 10d
		TEST AX, 8000H
		JNZ NEGATIVO
		JMP INICIO
	NEGATIVO:
		MOV buffer[SI], 45d
		NEG AX
		INC SI
	INICIO:
		XOR DX, DX
		CMP AX, 10d
		JB NEXT
		DIV BX
		INC DI
		PUSH DX
		JMP INICIO
	NEXT:
		PUSH AX
		INC DI
	I0:
		CMP DI, 00
		JE FINAL
		POP AX
		ADD AX, 48d
		MOV buffer[SI], AL
		INC SI
		DEC DI
		JMP I0
	FINAL:
		MOV buffer[SI], 36d
		POP DX
		POP CX
		POP BX
		POP AX
		POP SI
		POP DI
ENDM	



getChar macro
mov ah,01h
int 21h
endm

openF macro buffer,handle
mov ah,3dh
mov al,00h
lea dx,buffer
int 21h
jc  ErrorAbrir
mov handle,ax

endm

LeerF macro buffer,handle,numbytes,limite
mov ah,3fh
mov bx,handle
mov cx,numbytes
lea dx,buffer
int 21h
jc ErrorLeer
mov limite, ax
endm

createF macro buffer,handle
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
mov handle,ax
jc  ErrorCrear
endm

closeF	macro handler
mov	ah,3eh
mov bx,handler
int 21h
jc 	ErrorCerrar
endm

;==========================================================================================================

WriteF macro buffer,handler,size  ;======================= ESCRIBE EN EL ARCHIVO ============================
	push cx
	mov ah,40h
	xor bx,bx
	xor cx,cx
	xor dx,dx
	mov bx,handler
	mov cx,size
	lea dx,buffer
	int 21h
	jc ErrorEscribir
	pop cx

endm

;======================= ESCRIBE EN EL ARCHIVO HASTA EL LIMITE DE LA CADENA  ============================
WriteF_Calc_Size macro buffer,handler 
LOCAL CONTAR , AVANZAR , WRITE
	push cx
	xor di , di
	xor si , si 
	
CONTAR:
	cmp buffer[di] , 24h 	
    je  WRITE

AVANZAR:
    inc di
	inc si
	jmp CONTAR

		
WRITE:	
	mov ah,40h
	xor bx,bx
	xor cx,cx
	xor dx,dx
	mov bx,handler
	mov cx,si
	lea dx,buffer
	int 21h
	jc ErrorEscribir
	pop cx

endm



WriteF2 macro direccion , datos
  mov dx, direccion      	; prepara la ruta del archivo
  mov ah, 3ch     			; funcion 3c, crear un archivo
  mov cx, 0     			; crear un archivo normal
  int 21h       			; interrupcion DOS

  mov bx, ax    		    ; se guarda el puntero del archivo retornado de la funcion
  mov ah, 40h   		    ; funcion 40, escribir un archivo
  mov cx, 999
  mov dx, datos     		; preparacion del texto a escribir
  int 21h       			; interrupcion DOS

  mov ah, 3eh     			; funcion 3e, cerrar un archivo
  int 21h       			; interrupcion DOS

endm


; =================================================== IMPRIMIR HEXADECIMAL 

printHex macro  param
	LOCAL L1,L2
		push dx
		push si
		push di
		push bx
		push ax

		xor dx,dx
		mov di,00h
		mov si, 1
	L1:
		mov bl,0ah
		div bl
		mov dh,ah
		add dh,30h
		add ah,30h
		mov param[si],ah
		mov ah,00h
		cmp al,00h
		je L2
		dec si
		jmp L1
	L2:
	pop ax
	pop bx
	pop di 
	pop si
	pop dx
endm

;=============================================== comparar string 
compareString macro string1, string2, flag
LOCAL S1, EX, VF, S3, S4
	PUSH AX
	PUSH BX
	PUSH CX
	XOR DI, DI
	XOR AX, AX
S1:
	CMP string1[DI], 36d
	JE EX
	XOR BX, BX
	XOR CX, CX
	MOV BL, string1[DI]
	CMP BL, 65d
	JB S3
	CMP BL, 90d
	JA S3
	ADD BL, 32d 
S3:
	MOV CL, string2[DI]
	CMP CL, 65
	JB S4
	CMP CL, 90
	JA S4
	ADD CL, 32
S4:
	SUB BL, CL
	ADD AX, BX
	INC DI
	JMP S1
EX:
	CMP DI, 00H
	JNE VF
	MOV AX, 01H
VF:
	MOV flag, AX
	POP CX
	POP BX
	POP AX
endm

;=================================================== convertir un string a numero 

stringToNumber MACRO buffer, number
	LOCAL INICIO, NEGATIVO, FINAL, FINNN
		PUSH SI
		PUSH DI
		PUSH BX
		PUSH AX
		PUSH CX
		PUSH DX
		XOR BX, BX
		XOR DI, DI
		MOV BX, 10
		MOV SI, 01
		MOV number, 0000H
		CMP buffer[0], 45d
		JE NEGATIVO
		JMP INICIO
	NEGATIVO:
		MOV SI, 00d
		MOV DI, 01d
	INICIO:
		XOR CX, CX
		MOV CL, buffer[DI]
		CMP CL, 36d
		JE FINAL
		SUB CL, 48d
		MOV AX, number
		MUL BX
		ADD AX, CX
		MOV number, AX
		INC DI
		JMP INICIO
	FINAL:
		CMP SI, 00
		JNE FINNN
		NEG number
	FINNN:
		POP DX
		POP CX
		POP AX
		POP BX
		POP DI
		POP SI
ENDM


; Almacenar niveles en un array para luego ir reccorriendolos  despues de mil horasassasdsasjdbsadlkjbaskdja puta vida ojala me muera

;cadenaNivel1   db 45  dup ('$')
;cadenaNivel2   db 45  dup ('$')
;cadenaNivel3   db 45  dup ('$')
;cadenaNivel4   db 45  dup ('$')
;cadenaNivel5

getNivel macro Niveles , Temporal , nivelContar3
LOCAL INICIO , AVANZAR ,FIN , COMPARAR , SET_FINAL

		xor si , si 
		xor di , di
		xor bl , bl
		xor dh, dh
		mov ax , 00h 			; contador interno  	
		mov cl , 00h 			; es cero si aun no termina 
				
		INICIO:
				mov bl , Niveles[si]
				mov Temporal[di] , bl
				cmp bl , 3Bh			;punto y coma 
				je  COMPARAR
				cmp bl , 24h			; FIN DEL ARCHIVO 
				je FIN
				
		
				inc si 
				inc di
				jmp INICIO
				
		COMPARAR:
				
				;;print salto
				;getChar	
				xor di ,di 
				inc si
				cmp ax , 05h
				je  SET_FINAL				
				cmp ax , nivelContar3
				je FIN 
				inc ax
				cleanBuffer Temporal		
				jmp INICIO 

		SET_FINAL:
			mov cl , 01h 	         ; cl tiene el valor de 1 si ya terminaron los niveles 	
					
			
		FIN:
			;mov Temporal[di], 24h	


endm





;==================================================== get color 
compareColor macro color , hexa
LOCAL IS_AMARILLO , IS_ROJO , IS_AZUL , IS_NARANJA ,  IS_VERDE , FIN

	getColor color,  amarilloColor
	cmp  dl , 48 					; si es  1 es porque es igual 
	je   IS_AMARILLO 	
	getColor color , rojoColor
	cmp  dl , 48
	je   IS_ROJO
	getColor color , azulColor
	cmp dl , 48
	je  IS_AZUL
	getColor color , naranjaColor
	cmp dl , 48
	je IS_NARANJA
	getColor color , verderColor 
	cmp dl , 48
	je IS_VERDE
	
	mov hexa , 05h						; setea color  magenta por default 	
	jmp FIN 
	
	
	IS_AMARILLO:
	mov hexa , 0Eh						; amarillo
	jmp FIN

	IS_ROJO:
	mov hexa , 04h					   ; rojo	
	jmp FIN
	
	
	IS_AZUL:
	mov hexa , 01h					   ; AZUL	
	jmp FIN
	
	IS_NARANJA:
	mov hexa , 0Ch					   ; rojo	
	jmp FIN
	
	IS_VERDE:
	mov hexa , 0Ah					   ; rojo	
	jmp FIN
	
	FIN:

endm 


getColor macro   color , nombreEndata
LOCAL INICIO, AVANZAR, FIN , ERRORC
	xor si , si 
	xor di , di
	xor ax , ax
	mov dl , 48							; es verdadero dl 1
INICIO:
	mov al, color[si]
    mov ah, nombreEndata[di]
    cmp ah, 24h							; caracter de fin de linea 
    je  FIN  	
	cmp  al ,ah
	jne ERRORC 
AVANZAR:
    inc si
    inc di    
    jmp INICIO
ERRORC:
	mov dl, 49							; dl es  0 	
	jmp FIN
FIN:
   	
	
endm

FINISH_GAME macro  contador_tiempo , puntos_actuales 
	
push ax
push bx
push dx
mov  ax , contador_tiempo	
mov  bx , numero_tiempo_final  
cmp  ax , bx   
je   Get_Siguiente_Nivel
mov  dx , numero_puntos_nivel
cmp  dx , 00h
jng  Finalizar_Nivel

pop dx
pop bx 
pop ax	





endm 


