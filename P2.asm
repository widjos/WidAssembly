include MACRO.asm
include VIDEO.asm
;---------------------------------------------
.model small

.stack 100h



;----------------------------------------------DATA SECTION
.data

;Ointado

pintadoPremio1 db  46  ; no pintado 
pintadoPremio2 db  46  ; no pintado 
pintadoPremio3 db  46  ; no pintado 

pintadoObstaculo1 db 46
pintadoObstaculo2 db 46 


; OBSTACULOS PARA EL CARRO POSICIONES EN X 
obstaculo1_X   dw  50
obstaculo2_X   dw  100
obstaculo3_X   dw  150
obstaculo4_X   dw  200
obstaculo5_X   dw  250

obstaculo1_Y  dw   30;9600
obstaculo2_Y  dw   30;9600
obstaculo3_Y  dw   30;9600
obstaculo4_Y  dw   30;9600
obstaculo5_Y  dw   30

numero 		dw 0Ah 	
numero4		dw 00h	  
banderaFinal db 00h

contadorPremios     dw 00h
contadorObstaculos  dw  00h

cadenaNivel1   db 45  dup ('$')
cadenaNivel2   db 45  dup ('$')
cadenaNivel3   db 45  dup ('$')
cadenaNivel4   db 45  dup ('$')
cadenaNivel5   db 45  dup ('$')


; VECTORES DE POSICIONES PARA PINTAR LOS OBJETIVOS 

obstaculosPos  dw 50, 75 , 100 , 125 , 150 , 175 , 200 , 225 , 250 , 275   ; tamaño del vector  [10]
numeroObstaculos dw 0
numero_niveles_cargados db 3
 
; POSICIONES FINALES DEL CARRO E INICIAL 
posFinalCarro  dw  57646      ;59246  			;mov di, yPosition			; 125 * 320 = 40000
posInicioCarro dw  40000			; x = 46 ;  y = 183*320  -> Final 59246	del cuadro
borde 		   dw  16



; VECTORES DE COLORES DE CADA UNO DE LOS BLOCQUES DE LOS PUNTOS Y OBSTACULOS  
estrella1  dw 07h, 07h, 07h, 07h, 02h, 02h, 02h, 02h, 02h  ,02h ,02h ,07h ,07h ,07h ,07h
estrella2  dw 02h, 02h, 02h, 02h, 02h, 02h, 0Ah, 0Ah, 0Ah  ,02h ,02h ,02h ,02h ,02h ,02h

estrellaB1  dw 07h, 07h, 07h, 07h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh  ,0Eh ,0Eh ,07h ,07h ,07h ,07h
estrellaB2  dw 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Ch, 0Ch, 0Ch  ,0Eh ,0Eh ,0Eh ,0Eh ,0Eh ,0Eh

cadenaPause db 'Pause Mode','$0' 

; VECTOR DE NIVELES 

arrayNiveles      		db 5 dup(?)            ; Este array son 5 posiciones con una ccadenas vacias  caracteres llenas de $ 



; ENCABEZADO DE  USUARIO / NIVEL / PUNTOS / TIEMPO 
bufferNivelActual  db 'N1','$0'     
bufferPuntosActual db 00,'$0'      
bufferTime		   db 00,'$0'							; hora : minutos : segundos    
time_aux		   db  98  									                         ;Variable para verificar  si el timepo cambio y esta pone la velocidad del delay 
 
startAddr		   dw  0A000h                              ; Inicio del segmento de memoria de video VRAM 
startTablero       dw  0B2C0h



bufferReader	   db  50 dup('$')
bufferNombre       db  50 dup('$')
bufferContra       db  50 dup('$')
bufferCadenaIn     db  20 dup('$')										; asi se declara un vector	 times 15 db 0    
handleReader	   dw	?
buffer2			   db  10  dup('$')
bufferData		   db  200 dup('$')
bufferNiveles      db  200 dup('$')
number			   dw	0
limite			   dw	0


; Regresar estos alores a cero de nuevo luego de probar todo 
				   
string_nivel			 db 5 dup('$')
string_tiempo_nivel	   	 db  '000$'
string_puntos_nivel	   	 db  4 dup('$')						; puntos nivel lo incio siempre con 10
  	
string_puntos_seleccion	 db  '05$'					   	; puntos buenos 
string_puntos_esquivar	 db  '03$'						; puntos malos 
string_tiempo_premios	 db  '045$'						; cadena a modificar en cada nivel 
string_tiempo_obstaculo  db  '05$'						; cacena a modificar 	
string_tiempo_final		 db  '200$' 					;ejemplo para finalizar en 10 segundos 
string_color_personaje	 db 9 dup('$') 					; color 

string_tiempo_actual     db  '000$' 


numero_tiempo_final      dw 00h 
numero_nivel			 dw 00h
numero_tiempo_obstaculo  dw 00h
numero_tiempo_premios	 dw 00h
numero_tiempo_nivel	   	 dw 00h
numero_puntos_nivel	   	 dw 0Fh							; variable a compara si es igual a 00h 
numero_puntos_seleccion	 dw 00h
numero_puntos_esquivar	 dw 00h
numero_color_personaje	 dw 05h							;color default 

sumaBuenos 				 dw 00h
sumaMalo				dw  00h

contador_tiempo 		 dw 00h
tiempo_obstaculo  		  db 0
tiempo_premio 			  db 0

; ARCHIVOS  
archivoUsuarios    		db  'players.dat', 0	
nombreArchivoPuntos		db  'puntos.dat',0
comaCHAR				db  ',','$'
ptComaChar				db  ';','$' 
	;Todos los mensajes del encabezado
	ADMIN		db 'adminP,1234;'	
	UNIVERSIDAD db 10,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',         				0Ah,0Dh,'$0'
	FACULTAD 	db    'FACULTAD DE INGENIERIA',					        				0Ah,0Dh,'$0'
	ESCUELA 	db    'ESCUELA DE CIENCIAS Y SISTEMAS',									0Ah,0Dh,'$0'
	CURSO 		db    'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 B' , 				0Ah,0Dh,'$0'
	SEMESTRE    db    'VACACIONES DE JUNIO DEL 2019',									0Ah,0Dh,'$0'
    NOMBRE		db	  'WIDVIN JOSUE QUINONEZ DIAZ',										0Ah,0Dh,'$0'
	CARNET		db	  '201602952',														0Ah,0Dh,'$0'
	TITULO	    db    'PROYECTO',														0Ah,0Dh,'$0'		
	ENCAB1		db	10,'|                  Sesion Administrador                  |',		0Dh,'$0'
	SEPARADOR	db 	10,'|--------------------------------------------------------|',		0Dh,'$0'	
	ENCAB2		db 	10,'|                     Sesion Usuario                     |',		0Dh,'$0'
	ENCAB0		db 	10,'|                     MENU DE INICIO                     |',		0Dh,'$0'
	ENCAB3		db 	10,'-----------TOP 10 USERS ---------------------------------------',												0Ah,0Dh,'$0'
	salto		db	10,'  ','$'				
	menu1		db  10,'1. Ingresar.     ' ,										    0Ah,0Dh, '2. Registrar.' ,       0Ah,0Dh, '3. Salir.',  			0Ah,0Dh,'$0'    
	menu  		db  10,'1. Cargar Archivo',												0Ah,0Dh, '2. Salir',			 0Ah,0Dh, '$0'
	menuUser	db  10,'1. Cargar Archivo',												0Ah,0Dh, '2. Jugar',			 0Ah,0Dh, '3. Salir.',   			0Ah,0Dh,'$0' 
	menuAdmi	db  10,'1. TOP 10 Puntos',												0Ah,0Dh, '2. Salir',			 0Ah,0Dh, '$0'							 	
	ingNombre   db  10,'Ingrese nombre de Usuario: ',									0Ah,0Dh,'$0'
  	ingContra   db  10,'Ingrese contrase',164,'a:  ',									0Ah,0Dh,'$0'
	menu2  		db  10,'1. Mostrar Data',							    				0Ah,0Dh, '2. Contar Caracteres', 0Ah,0Dh, '3. Cerrar Archivo',	0Ah,0Dh,'$0''$0'
	correcto	db  10,'Se ha cargado el archivo',										0Ah,0Dh,'$0'
	load 		db 	10,'Ingrese el nombre del archivo: \n Ejemplo: archivo.extension',	0Ah,0Dh,'$0'
	finish		db  10,'Adios',															0Ah,0Dh,'$0'
	countChar	db	10,'Los caracteres totales son:		',								0Ah,0Dh,'$0'
	error1		db	10,'--> ERROR AL ABRIR EL ARCHIVO PUDE QUE NO EXISTA',	'$'
	error2		db	10,'--> ERROR AL CERRAR EL ARCHIVO', '$'
	error3		db	10,'--> ERROR AL ESCRIBIR EN EL ARCHIVO','$'
	error4		db 	10,'--> ERROR AL LEER  EL ARCHIVO',		'$'
	error5		db 	10,'--> ERROR AL CREAR  EL ARCHIVO',		'$'
	errorLog1   db  10,'EL USUARIO NO EXISTE', '$'
	exitoLog1   db  10,'USUARIO ENCONTRADO :)', '$'
	msg_level   db  '--> NEXT LEVEL NOW <--$'
	msg_finish  db  '--> GAME OVER <--$' 	
	
;Colores que puede recibir 
	amarilloColor db 'amarillo$'
	rojoColor     db 'rojo$'
	azulColor     db 'azul$'
	naranjaColor  db 'naranja$'
	verderColor   db 'verde$'




DOW           DW        00
ddd			  db		'00$'
nD			  dw		12h		
numer         db       '19$'
			 
DAY1          DB        " SUNDAY  $"


NivelActualEjecucion	db 300 dup('$') 
;---------------------------------------------- CODE SECTION
.code
	 


	main proc
			PUSH DS
			SUB AX, AX
			PUSH AX
			MOV DX ,@data		
			MOV DS,DX
		
		Inicio	:
				print 	SEPARADOR
				
				print 	ENCAB0
				print 	SEPARADOR
				print 	salto
				print 	menu1
				print 	salto
			
				 
				getChar
				
				cmp    	al,31h
				je	    Ingresar
				cmp     al,32h
                je 		Registrar
				cmp		al,33h
				je		Exit	
				jmp		Inicio
	
		
		Ingresar:
				;------------- Se carga el archivo de usuarios primero 
				openF   			archivoUsuarios,handleReader
				LeerF   			bufferData,handleReader, sizeof bufferData,limite			; Carga el archivo al bufferData
				cleanBuffer  		bufferNombre												; Clean the name buffer2			
				cleanBuffer			bufferContra												; Clean the password buffer
				cleanBuffer			bufferCadenaIn												; Clean the name,password buffer
					
				print   	 		ingNombre	
				getRuta 	 		bufferNombre												;Se cargan las cadenas del nombre 
                print   	 		ingContra	
				getRuta 	 		bufferContra												;Se cargan los datos de la contraseña 				
                appendBuffer 		bufferNombre,bufferContra,bufferCadenaIn		    		; Se crea la cadena a comparar en la entrada
				VerificarUsuario    bufferData, bufferCadenaIn , exitoLog1 , errorLog1 
                cmp 				bl , 48
                je 					ErrorLogin				
				cmp					bl , 49														; Si existe el usuario en el listado				
				je					ComprobarTipoLogin
		
		
		Registrar:
				
				cleanBuffer			bufferData													; Limpiar el buffer de datos 
				openF   			archivoUsuarios ,handleReader								; Abrir el archivo para escribir en el 
				LeerF   			bufferData		,handleReader, sizeof bufferData,limite 	; Carga el archivo al bufferData
				closeF 				handleReader												; Cierra el archivo players.dat 
				
				createF  			archivoUsuarios , handleReader								; Vuelve a crear el archivo de nuevo
				cleanBuffer  		bufferNombre												; Clean the name buffer2			
				cleanBuffer			bufferContra												; Clean the password buffer
				cleanBuffer			bufferCadenaIn												; Clean the name,password buffer
				
				print   			ingNombre
				getRuta 			bufferNombre
                print   			ingContra
				getRuta 			bufferContra
				appendBuffer 		bufferNombre	, bufferContra , bufferCadenaIn		    	; Se crea la cadena que se agregara al archivo
				
				WriteF_Calc_Size  	bufferData      , handleReader								; Escribe el contenido del archivo players.dat 
				WriteF_Calc_Size  	bufferCadenaIn  , handleReader								; Escribe el nuevo usuario 
				closeF 				handleReader												; Cierra el archivo creado 
				print 				salto 
				jmp 				Inicio														; Regresa el flujo del programa al main 				
				
	
		PrincipalMenu:		
				print UNIVERSIDAD
				print FACULTAD
				print salto
				print menu
				print salto
				getChar
				cmp 	al,31h
				je		OpenFile
				cmp		al,32h
				je		Exit
				jmp	    PrincipalMenu				
		
		

				
		ComprobarTipoLogin:
				IsAdmin  ADMIN , bufferCadenaIn
				cmp  	 dl    , 48
				je 		AdminMenu
				cmp 	 dl    , 49
				je		UserMenu
				

			
		AdminMenu:
				print SEPARADOR
				print ENCAB1
				print SEPARADOR
				print salto
				print menuAdmi
				getChar
				print	salto
				cmp 	al,31h
				je		Top10
				cmp		al,32h
				je		Inicio
				jmp		AdminMenu	
				
				
		Top10   :
				print   ENCAB3
				getChar
				print	salto
				jmp 	Inicio
		
		UserMenu:
				print SEPARADOR
				print ENCAB2
				print SEPARADOR
				print salto
				print UNIVERSIDAD 		
                print FACULTAD 	
                print ESCUELA 	
                print CURSO 		
                print SEMESTRE    
                print NOMBRE		
                print CARNET		
                print TITULO
				print salto
				print menuUser
				getChar
				print	salto
				
				cmp 	al,31h
				je		CargarNiveles
				cmp		al,32h
				je		PlayGame
				cmp		al,33h
				je		Inicio
				
				jmp   UserMenu
		
		CargarNiveles:									;Aqui solo se cargaran los niveles al buffer que los contrenda durante su ejecucion 
				mov numero4  ,   00h
				
				cleanBuffer     bufferNiveles
				print 			load
				print 			salto
			    getRuta			bufferReader
				print           bufferReader
				openF			bufferReader ,handleReader
				LeerF			bufferNiveles,handleReader, sizeof bufferNiveles,limite
				print 			salto
				closeF 			handleReader

			
				jmp   UserMenu
				
       		
		PlayGame:
		        ;cleanBuffer     bufferNiveles
                jmp   EnterVideoMode				
				;jmp   UserMenu	
		
		EnterVideoMode:
		        
				mov numero_puntos_nivel    , 14h										; puntos iniciales del jugador 20 
				
				
				mov   ah, 00h           												; set video mode
				mov   al, 13h															; choose the video mode wide of screen
                int   10h																; execute the iterruption 
														
				mov   ah ,0Bh 															; set configuration	   
				mov   bh ,00h															; to the background color 
				mov   bl ,00h															; set black color
                int   10h																; execute the iterruption 


				
				
		
		VerificarTiempo:				
				

			 cmp  numero4 , 05h
			 je  Finalizar_Nivel														; Si el contador de niveles que en este caso es numero4 porque ya estaba a verfa de assambly 
	
			
			 call RESET_VALORES	
			 call GET_LEVEL
			 call SET_PARAMETROS_NIVEL 
			
			 call PARAMETROS
			 getChar
			 getChar
			 
          
		MoverCarro:	
				GetTime					; macro que devuelve el tiempo // VIDEO 					
				cmp  dl, time_aux		;	
				je   MoverCarro
				
				;Se incrementan las variables para actualizar cosas 											;
				
				inc tiempo_obstaculo
				inc tiempo_premio
				inc contador_tiempo
				
				mov  time_aux , dl	
				
				;================================================== verificacion si el tiempo es igual al del nivel = termina ; verificacion si los puntos son igual a 00 termina 
				
				
				FINISH_GAME contador_tiempo , numero_tiempo_final , numero_puntos_nivel									; macro que reciebe el numero de tiempo que lleva el juego y el numero de puntos 		
				
			    call CONVERTIR_VALORES_HEX_A_STRING																		; Convierte todos los valores antes de imrpimirlos en la pantalla 
				
			
				Print_VideoString  bufferNombre       		  , 00h , 01h , 03h											; Imprime una cadena estatica en la pantalla en modo video : , cadena , pagina , fila , columna   
				Print_VideoString  string_nivel		  		  , 00h , 01h , 0Ah
				Print_VideoString  string_puntos_nivel 		  , 00h , 01h , 12h
				Print_VideoString  string_tiempo_actual		  , 00h , 01h , 1Ch   	
			
				PintarCarretera       startAddr				
			    PintarCarroMoviendo   startAddr, posFinalCarro, posInicioCarro , numero_color_personaje

; 				Aqui deberia ir el contador para saber que tipo de archivo hay que desplegar  de objeto hay que desplegar 	
				
	
			    call PREMIOS_PINTAR
			    call OBSTACULOS_PINTAR
				
				call UPDATE_PREMIOS
			    call UPDATE_OBSTACULOS
			
					
				CALL VERIFICAR_PUNTOS1
				CALL VERIFICAR_PUNTOS2
				CALL VERIFICAR_PUNTOS3
				CALL VERIFICAR_PUNTOS4
				CALL VERIFICAR_PUNTOS5		
			
; INTERRUPCION  16H QUE SE ACTIVA ZF si hay una tecla precionada si no no hace la interrupcion y sigue 			
				mov ah , 01h 
				int 16h 
				jz  MoverPiezas 
				
				GetCh2 																					;Obtener tecla de movimiento 													
				cmp  al, 4Bh																			; The key is the left
				je  	 MoverCarroIzquierda
				cmp  al, 4Dh	 																		; The key is right 	
				je  	 MoverCarroDerecha
				cmp  al, 1Bh
				je  	 PauseGame		
                jmp      MoverCarro				
				
				
		MoverCarroDerecha:
																										; Jump to MoverCarro  if posFinalCarro is still < 59504	
				cmp posFinalCarro , 57900
				jl  Incremetar_CarroX
				jmp MoverCarro														
				
		
		MoverCarroIzquierda:        																	; Jump to MoverCarro  if posFinalCarro is still < 59504
				cmp posFinalCarro, 57646     
				jg  Decrementar_CarroX
				jmp MoverCarro														
			
		Incremetar_CarroX:
				add posInicioCarro, 5
				add posFinalCarro, 5			
				jmp MoverCarro
		
		Decrementar_CarroX:
				sub posInicioCarro , 5
				sub posFinalCarro  , 5 
				jmp MoverCarro
		

		Finalizar_Nivel:											; Agui se Finaliza el Juego definitivamente 
				call VENTANA_FINALIZO_JUEGO
				
				cleanBuffer			bufferData													    ; Limpiar el buffer de datos 
				openF   			nombreArchivoPuntos ,handleReader								; Abrir el archivo para escribir en el 
				LeerF   			bufferData		,handleReader, sizeof bufferData,limite 		; Carga el archivo al bufferData
				closeF 				handleReader													; Cierra el archivo players.dat 
				
				createF  			nombreArchivoPuntos , handleReader								; Vuelve a crear el archivo de nuevo

				
				WriteF_Calc_Size  	bufferData      		, handleReader							; Escribe el contenido del archivo players.dat 
				WriteF_Calc_Size  	salto  					, handleReader							; Escribe el nuevo usuario 
				WriteF_Calc_Size    bufferNombre    		, handleReader
				WriteF_Calc_Size    comaCHAR				, handleReader
				WriteF_Calc_Size    string_nivel    		, handleReader
				WriteF_Calc_Size    comaCHAR				, handleReader
				WriteF_Calc_Size    string_puntos_nivel		, handleReader
				WriteF_Calc_Size    ptComaChar   			, handleReader
				
				
				closeF 				handleReader												; Cierra el archivo creado 			
	
					
				
				
				getChar
				getChar
				mov numero4 , 00h									; Restea el contador de niveles 
				jmp RegresarModoTexto								
		
		Get_Siguiente_Nivel:
				inc numero4	    ;				 se actualiza el contador
												; Aqui se recorren los NIVELES RESTANTES QUE VENIAN EN EL ARCHIVO DE NIVELES 
				call VENTANA_NUEVO_NIVEL
				getChar
				getChar
				jmp VerificarTiempo
		

		RegresarModoTexto:
				;regrear al modo anterior
				mov ah,00h 										;modo video
				mov al,03h 										;80x25 16 colores
				int 	10h
                jmp UserMenu		

		MoverPiezas :
				                
				call UPDATE_OBJETIVOS	
				jmp  MoverCarro

		PauseGame :
				;Print_VideoString  cadenaPause	  , 00h , 03h , 19h 
				
				GetCh2												; Lee caracter de entrada  sin mostrarlo en pantall 
				cmp al , 1Bh										
				je  MoverCarro
				cmp al , 32 
				je RegresarModoTexto
				jmp PauseGame
			
		
		OpenFile:
				print 	salto
				print	load
				print 	salto
				getRuta	bufferReader
				openF	bufferReader,handleReader
				LeerF	bufferData,handleReader, sizeof bufferData,limite
				print 	salto
		
		OpenFile2:		
				print 	salto
				print	menu2
				print 	salto
				getChar
				print	salto
				cmp 	al,31h
				je		ShowData
				cmp		al,32h
				je		CountCharacters
				cmp		al,33h
				je		CloseFile
				jmp		OpenFile
		
		ShowData:	
				print salto
				print bufferData
				print salto
				getChar
				jmp	OpenFile2
		
		CloseFile:
				jmp	PrincipalMenu
		
		ErrorAbrir:
			print error1
			print salto
			getChar
			jmp	 UserMenu
		
		ErrorCrear:
			print error5
			print salto
			getChar
			jmp	 UserMenu	
		
		ErrorLeer:
			print error4
			print salto
			getChar
			jmp	UserMenu
		
		ErrorLogin:
		    print errorLog1
			print salto
			getChar
			jmp   Inicio
			
		ErrorEscribir:
		    print error3
			print salto
			getChar
			jmp   Inicio
			
		ErrorCerrar:
            print error2
			print salto
			getChar
			jmp   Inicio 		

		CountCharacters:
			print countChar
			contarCaracteres bufferData,number,buffer2,limite
			print salto
			getChar
			jmp	 PrincipalMenu


		Exit:
			print finish
			mov ah,4ch
			int 21h	
			
	main endp
	
	
	GET_LEVEL PROC 

				cleanBuffer    NivelActualEjecucion		
				getNivel       bufferNiveles, NivelActualEjecucion , numero4  				; Almacenar los niveles en un arreglo para ir recorriendolo 
				mov 		   banderaFinal , cl
				
				
				cleanBuffer  string_tiempo_obstaculo
				cleanBuffer  string_tiempo_premios
				cleanBuffer  string_tiempo_final
				cleanBuffer  string_puntos_seleccion
				cleanBuffer string_puntos_esquivar
				cleanBuffer string_color_personaje
				
					
				
				
				xor si , si 
				xor di , di
				xor bl , bl
			
				INICIO2:
					mov bl , NivelActualEjecucion[si]
					cmp bl , 3AH			;Encuentra los dos puntos primero 
					je  NIVEL2
					cmp bl , 44			; Encuentra la primera coma
					je  TIEMPO_OBS2 	
					cmp bl , 59			;punto y coma   2Ch coma ; 3Ah dos puntos 
					je  FIN2
					cmp bl , 24h			; FIN DEL ARCHIVO 
					je FIN2
					
			
					inc si 
					;inc di
					jmp INICIO2
		
				NIVEL2:
					xor di , di 
					mov string_nivel[di] , 78
					inc di 
					inc si
					mov bl , NivelActualEjecucion[si]
					mov string_nivel[di] , bl  
					mov string_nivel [di+1] , 24h 
					inc si
					jmp INICIO2
				
				TIEMPO_OBS2:
					xor di , di
					inc si 
				TIEMPO_OBS3:	
					
					mov bl , NivelActualEjecucion[si] 
					cmp bl , 44
					je  TIEMPO_PREMIO1	
					mov string_tiempo_obstaculo[di] , bl
					mov string_tiempo_obstaculo [di+1] , 24h 		
					inc di	
					inc si 
					jmp TIEMPO_OBS3
			
				TIEMPO_PREMIO1:
					xor di , di
					inc si 
					
				TIEMPO_PREMIO2:	
					mov bl , NivelActualEjecucion[si] 
					cmp bl , 44
					je  TIEMPO_NIVEL	
					mov string_tiempo_premios[di] , bl
					mov string_tiempo_premios [di+1] , 24h 	
					inc di
					inc si 	
					jmp TIEMPO_PREMIO2
					
				TIEMPO_NIVEL:
					xor di , di
					inc si 
					
				TIEMPO_NIVEL2:	
					mov bl , NivelActualEjecucion[si] 
					cmp bl , 44
					je  PUNTOS_SELECCION	
					mov string_tiempo_final [di] , bl 
					mov string_tiempo_final [di+1] , 24h 
					inc di
					inc si 	
					jmp TIEMPO_NIVEL2	
					
					
				PUNTOS_SELECCION:
					xor di , di
					inc si 
					
				PUNTOS_SELECCION2:	
					mov bl , NivelActualEjecucion[si] 
					cmp bl , 44
					je  PUNTOS_ESQUIVAR	
					mov string_puntos_seleccion[di] , bl 
					mov string_puntos_seleccion [di+1] , 24h 					
					inc di
					inc si 	
					jmp PUNTOS_SELECCION2		

				PUNTOS_ESQUIVAR:
					xor di , di
					inc si 
				PUNTOS_ESQUIVAR1:
					mov bl , NivelActualEjecucion[si] 
					cmp bl , 44
					je  COLOR	
					mov string_puntos_esquivar[di] , bl 
					mov string_puntos_esquivar [di+1] , 24h 	
					inc di	
					inc si
				jmp PUNTOS_ESQUIVAR1	
				
				COLOR:
					xor di , di
					inc si 
					
				COLOR1:	
					mov bl , NivelActualEjecucion[si]
					cmp bl , 44
					je  COLOR	
					cmp bl , 59
					je  FIN2	
					mov string_color_personaje[di] , bl 
					mov string_color_personaje [di+1] , 24h 					
					inc di	
					inc si
				
				jmp COLOR1
				

				
				FIN2: 
				
		ret	

	
	
	
	GET_LEVEL ENDP
	

;=========================================== VERIFIACION DE COLICIONES CON EL CARRITO =====================================

;OBSTACULO 1 
	VERIFICAR_PUNTOS2 PROC 
				
			
			PuntoMalo1:
				cmp posInicioCarro , 	40050			; 40010  estas son las posiciones del primer blouqe  ; posicion inicial + 10 
				jg PuntoMalo2
				ret
				
			PuntoMalo2:
				cmp posFinalCarro ,   	57749			; 57696   ; posicion final del carro + 50		
				jl  ObjectoM1
				ret
				
			ObjectoM1:
				cmp obstaculo2_Y ,   100     ; cuando el objeto este en una poscion mayor 100 en Y 
				jg  RestarPuntos
				ret
					
			RestarPuntos:
				push cx
				mov  cx                  ,  numero_puntos_esquivar 
				sub  numero_puntos_nivel  , cx                     ;Aqui se restara el punteo por objetos malos 			
				mov obstaculo2_Y         ,  30;9600							  ; Se restablece el lugar de la figura que esta cayendo 	
			    pop cx 
				ret 
	
	VERIFICAR_PUNTOS2 ENDP 


; OBSTACULO 2


	VERIFICAR_PUNTOS4 PROC

			PuntoMalo1:
				cmp posInicioCarro , 	40150			; 40010  estas son las posiciones del primer blouqe  ; posicion inicial + 10 
				jg PuntoMalo2
				ret
				
			PuntoMalo2:
				cmp posFinalCarro ,   	57847			; 57696   ; posicion final del carro + 50		
				jl  ObjectoM1
				ret
				
			ObjectoM1:
				cmp obstaculo4_Y ,   100     ; cuando el objeto este en una poscion mayor 100 en Y 
				jg  RestarPuntos
				ret
					
			RestarPuntos:
				push cx
				mov  cx                  ,  numero_puntos_esquivar 
				sub  numero_puntos_nivel  , cx                     ;Aqui se restara el punteo por objetos malos 			
				mov obstaculo4_Y         ,  30;9600							  ; Se restablece el lugar de la figura que esta cayendo 	
			    pop cx 
				ret



	VERIFICAR_PUNTOS4 ENDP 	
	
	



			
; BONIFICACION 1	
	VERIFICAR_PUNTOS1 PROC 
				
			
			PuntoBueno1:
				cmp posInicioCarro , 	40010  ; estas son las posiciones del primer blouqe  ; posicion inicial + 10 
				jg PuntoBueno2
				ret
				
			PuntoBueno2:
				cmp posFinalCarro ,    57696   ; posicion final del carro + 50		
				jl  ObjectoM1
				ret
				
			ObjectoM1:
				cmp obstaculo1_Y ,   100     ; cuando el objeto este en una poscion mayor 100 en Y 
				jg  SumarPuntos
				ret
					
			SumarPuntos:
				push cx
				mov  cx                  ,  numero_puntos_seleccion 
				add  numero_puntos_nivel  , cx                     ;Aqui se restara el punteo por objetos malos 			
				mov obstaculo1_Y         ,  30;9600							  ; Se restablece el lugar de la figura que esta cayendo 	
			    pop cx 
				ret 

			
				
	
	VERIFICAR_PUNTOS1 ENDP 	
	

;BONIFICACION 2	
	VERIFICAR_PUNTOS3 PROC
			PuntoBueno1:
				cmp posInicioCarro , 	40110  ; estas son las posiciones del primer blouqe  ; posicion inicial + 10 
				jg PuntoBueno3
				ret
		
			PuntoBueno3:
				cmp posFinalCarro ,    57799   ; posicion final del carro + 50		
				jl  ObjectoM3
				ret
				
			ObjectoM3:
				cmp obstaculo3_Y ,   100     ; cuando el objeto este en una poscion mayor 100 en Y 
				jg  SumarPuntos2
				ret
					
			SumarPuntos2:
				push cx
				mov  cx                  ,  numero_puntos_seleccion 
				add  numero_puntos_nivel  , cx                     ;Aqui se restara el punteo por objetos malos 			
				mov obstaculo3_Y         ,  30;9600							  ; Se restablece el lugar de la figura que esta cayendo 	
			    pop cx 
				ret 	

	VERIFICAR_PUNTOS3 ENDP 	
	
;BONIFICACION 3	
	VERIFICAR_PUNTOS5 PROC
			PuntoBueno1:
				cmp posInicioCarro , 	40195  ; estas son las posiciones del primer blouqe  ; posicion inicial + 10 
				jg PuntoBueno3
				ret
		
			PuntoBueno3:
				cmp posFinalCarro ,    57897   ; posicion final del carro + 50		
				jl  ObjectoM3
				ret
				
			ObjectoM3:
				cmp obstaculo5_Y ,   100     ; cuando el objeto este en una poscion mayor 100 en Y 
				jg  SumarPuntos2
				ret
					
			SumarPuntos2:
				push cx
				mov  cx                  ,  numero_puntos_seleccion 
				add  numero_puntos_nivel  , cx                    			  ; Aqui se restara el punteo por objetos malos 			
				mov obstaculo5_Y         ,  30;9600							  ; Se restablece el lugar de la figura que esta cayendo 	
			    pop cx 
				ret 	

	VERIFICAR_PUNTOS5 ENDP 	
		


; PROCEDIMIENTO PARA ESCRIBRIR LOS RESULTADOS 	
	WRITE_SCORES PROC 

		;		cleanBuffer			bufferData													    ; Limpiar el buffer de datos 
		;		openF   			nombreArchivoPuntos ,handleReader								; Abrir el archivo para escribir en el 
		;		LeerF   			bufferData		,handleReader, sizeof bufferData,limite 		; Carga el archivo al bufferData
		;		closeF 				handleReader													; Cierra el archivo players.dat 
		;		
		;		createF  			nombreArchivoPuntos , handleReader								; Vuelve a crear el archivo de nuevo
		;
		;		
		;		WriteF_Calc_Size  	bufferData      		, handleReader							; Escribe el contenido del archivo players.dat 
		;		WriteF_Calc_Size  	salto  					, handleReader							; Escribe el nuevo usuario 
		;		WriteF_Calc_Size    bufferNombre    		, handleReader
		;		WriteF_Calc_Size    comaCHAR				, handleReader
		;		WriteF_Calc_Size    string_nivel    		, handleReader
		;		WriteF_Calc_Size    comaCHAR				, handleReader
		;		WriteF_Calc_Size    string_puntos_nivel		, handleReader
		;		WriteF_Calc_Size    ptComaChar   			, handleReader
		;		
		;		
		;		closeF 				handleReader												; Cierra el archivo creado 			
		;
		;		ret 
	
	WRITE_SCORES ENDP 
	
	
	
	UPDATE_PREMIOS PROC
		
		Paint:	
		 cmp pintadoPremio1 , 47
		 je  Pintar1 
		 cmp pintadoPremio2, 47
		 je  Pintar2
		 cmp pintadoPremio3, 47
		 je  Pintar3
		 ret 

		

			
			; Moviemiento y posicion y el update de sus posiciones 


		Pintar1:
			Pintar_Obstaculo 	  startAddr, obstaculo1_X , obstaculo1_Y   , estrellaB1      , estrellaB2
			
			add obstaculo1_Y , 1
			cmp obstaculo1_Y , 150
			jg  R_Premio1
			cmp pintadoPremio2, 47
			je  Pintar2
			cmp pintadoPremio3, 47
			je  Pintar3
			ret 
			

		Pintar2:
			Pintar_Obstaculo 	  startAddr, obstaculo3_X , obstaculo3_Y   , estrellaB1      , estrellaB2
			add obstaculo3_Y , 1
			cmp obstaculo3_Y , 150
			jg  R_Premio2
			cmp pintadoPremio3 , 47 
			je Pintar3
			ret 
					
		Pintar3:
			Pintar_Obstaculo 	  startAddr, obstaculo5_X , obstaculo5_Y   , estrellaB1      , estrellaB2
			
			add obstaculo5_Y , 1
			cmp obstaculo5_Y , 150
			jg  R_Premio3
			
			ret 
			
		R_Premio1:
			mov obstaculo1_Y , 30
			mov pintadoPremio1 , 46
			
			ret

		R_Premio2:
			mov obstaculo3_Y , 30
			mov pintadoPremio2 , 46
		ret			
;			jmp Paint

		R_Premio3:	
			mov obstaculo5_Y , 30
			mov pintadoPremio3 , 46
	;ret		
			jmp Paint
		
	UPDATE_PREMIOS ENDP


	UPDATE_OBSTACULOS PROC
		
		Paint:	
		 cmp pintadoObstaculo1 , 47
		 je  Pintar1 
		 cmp pintadoObstaculo2, 47
		 je  Pintar2
		 ret 

		

			
			; Moviemiento y posicion y el update de sus posiciones 


		Pintar1:
			Pintar_Obstaculo 	  startAddr, obstaculo2_X , obstaculo2_Y   , estrella1      , estrella2
			
			add obstaculo2_Y , 1
			cmp obstaculo2_Y , 150
			jg  R_Obstaculo1
			cmp pintadoObstaculo2, 47
			je  Pintar2
			ret 
			

		Pintar2:
			Pintar_Obstaculo 	  startAddr, obstaculo4_X , obstaculo4_Y   , estrella1      , estrella2
			add obstaculo4_Y , 1
			cmp obstaculo4_Y , 150
			jg  R_Obstaculo2
			ret 
					
			
		R_Obstaculo1:
			mov obstaculo2_Y , 30
			mov pintadoObstaculo1 , 46
			
			ret

		R_Obstaculo2:
			mov obstaculo4_Y , 30
			mov pintadoObstaculo2 , 46
		ret			
;			jmp Paint


		
	UPDATE_OBSTACULOS ENDP


		
	OBSTACULOS_PINTAR PROC
      
			mov  bx , contador_tiempo    
			cmp  bx  , sumaMalo
			je   AgregarPremio 
			ret 
			
			AgregarPremio:
			
					mov ax  				 , 	 sumaMalo
					add ax , numero_tiempo_obstaculo
					mov sumaMalo , ax 
					inc contadorObstaculos
					cmp contadorObstaculos , 01h
					je  Acciones1 		
					cmp contadorObstaculos , 02h
					je  Acciones2 
					jmp Final_Obstaculos 		
	
			Acciones1: 
				;Pintar_Obstaculo 	  startAddr, obstaculo1_X , obstaculo1_Y   , estrellaB1      , estrellaB2
				mov pintadoObstaculo1 , 47
				ret		
			Acciones2:
				;Pintar_Obstaculo 	  startAddr, obstaculo2_X , obstaculo2_Y   , estrellaB1      , estrellaB2	
				mov pintadoObstaculo2 , 47
				ret	
				
			Final_Obstaculos:
				mov contadorObstaculos , 00h
				mov contadorObstaculos , 00h
				ret 	
	
	
	
	OBSTACULOS_PINTAR ENDP
	

	
	PREMIOS_PINTAR PROC
	
	
		
	        mov  bx , contador_tiempo    
			cmp  bx  , sumaBuenos
			je   AgregarPremio 
			ret 
			
			AgregarPremio:
			
					mov ax  				 , 	 sumaBuenos
					add ax , numero_tiempo_premios
					mov sumaBuenos , ax 
					inc contadorPremios
					cmp contadorPremios , 01h
					je  Acciones1 		
					cmp contadorPremios , 02h
					je  Acciones2 
					cmp contadorPremios , 03h
					je  Acciones3
					jmp Final_Premios 		
	
			Acciones1: 
				;Pintar_Obstaculo 	  startAddr, obstaculo1_X , obstaculo1_Y   , estrellaB1      , estrellaB2
				mov pintadoPremio1 , 47
				ret		
			Acciones2:
				;Pintar_Obstaculo 	  startAddr, obstaculo2_X , obstaculo2_Y   , estrellaB1      , estrellaB2	
				mov pintadoPremio2 , 47
				ret	
			Acciones3:
				;;Pintar_Obstaculo 	  startAddr, obstaculo2_X , obstaculo2_Y   , estrellaB1      , estrellaB2	
				mov pintadoPremio3 , 47
				;;mov contadorPremios , 00h
				ret
				
			Final_Premios:
				mov contadorPremios , 00h
				mov contadorPremios , 00h
				ret 
	
	PREMIOS_PINTAR ENDP 
	
	
	CONVERTIR_VALORES_HEX_A_STRING PROC

			cleanBuffer      string_puntos_nivel 
			numberToString   string_puntos_nivel , numero_puntos_nivel			; CONVERSION DE LOS PUNTOS ACTUALES PARA MOSTRARLOS EN PANTALLA 
			numberToString   string_tiempo_actual, contador_tiempo 				; CONVERSION DE DEL TIEMPO EN HEX A STRING PARA MOSTRAR 
			ret 	
	CONVERTIR_VALORES_HEX_A_STRING ENDP
	
	
	
	UPDATE_OBJETIVOS PROC 
				
				cmp pintadoPremio1, 47
				je  sumar1
				cmp pintadoPremio2, 47
				je  sumar2
				cmp pintadoPremio3, 47
				je  sumar3
				ret 

				sumar1:
					add obstaculo1_Y , 2
					cmp pintadoPremio2, 47
					je  sumar2
					cmp pintadoPremio3, 47
					je  sumar3
					ret 

				sumar2:
					
			;		add obstaculo2_Y , 1
					add obstaculo3_Y , 2 
					cmp pintadoPremio3, 47
					je  sumar3;		
			
				;	add obstaculo4_Y , 1
				;	add obstaculo5_Y , 1  
					ret 
		
				sumar3:
					add obstaculo5_Y , 2  
					ret 
	
	
	UPDATE_OBJETIVOS ENDP 
	
	
	RESET_VALORES PROC 
				
			mov posFinalCarro  		,  57646  ;59246
			mov posInicioCarro 		,  40000
			mov obstaculo1_Y  		,  30
			mov obstaculo2_Y  		,  30
			mov obstaculo3_Y  		,  30
			mov obstaculo4_Y  		,  30
			mov obstaculo5_Y  		,  30
			mov contadorPremios     ,  00h
			mov contadorObstaculos  ,  00h 
			
			mov numero_color_personaje , 00h
			mov numero_puntos_esquivar , 00h
			mov numero_tiempo_obstaculo, 00h
			mov numero_tiempo_premios  , 00h
			mov numero_tiempo_final    , 00h
			mov contador_tiempo 	   , 00h 	
			mov sumaBuenos		       , 00h
			mov sumaMalo			   , 00h	
	
				ret
	RESET_VALORES ENDP
	
	
	VENTANA_NUEVO_NIVEL PROC 
					
			CleanVideo
			Print_VideoString  msg_level  , 00h , 07h , 0Ah 
			getChar

			ret
	VENTANA_NUEVO_NIVEL ENDP 
	
	
	PARAMETROS PROC
			
				CleanVideo
				
				Print_VideoString  string_nivel       				  , 00h , 05h , 04h	
				Print_VideoString  string_puntos_nivel       		  , 00h , 05h , 08h	
				
			
			ret 
	
	PARAMETROS ENDP
 	
	
	
	VENTANA_FINALIZO_JUEGO PROC 
			CleanVideo
			Print_VideoString  msg_finish  , 00h , 07h , 0Ah
			getChar
			
			ret 
	VENTANA_FINALIZO_JUEGO ENDP 	
			
	
	
	SET_PARAMETROS_NIVEL PROC 
								stringToNumber  string_tiempo_final    , numero_tiempo_final	
								stringToNumber  string_puntos_seleccion, numero_puntos_seleccion    ; puntos al topar un objeto azul  
								stringToNumber  string_puntos_esquivar , numero_puntos_esquivar		; puntos al topar con un objeto malo 	
								stringToNumber  string_tiempo_obstaculo, numero_tiempo_obstaculo
								stringToNumber  string_tiempo_premios  , numero_tiempo_premios		
								compareColor   string_color_personaje   ,  numero_color_personaje  	
								
								mov ax         , numero_tiempo_premios 			
								add sumaBuenos , ax
								xor ax , ax
								mov ax         , numero_puntos_esquivar 
								add sumaMalo   , ax
			ret 
			
	SET_PARAMETROS_NIVEL ENDP 	
	
     
		

	
	
end

