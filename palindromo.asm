		.data
text1:		.asciiz "Ingrese un palindromo :"
text2:		.asciiz	"Su palabra es:"
palindromo:	.space 1024			#asigno a palindromo un tamaño de 1024 bytes
contras:	.space 1024			#asigno a palindromo un tamaño de 1024 bytes
fin_palindromo:	.asciiz	"\n"
espacio:	.asciiz	" "
verificar:	.space 1			#reservo 1 byte para mi verificador
nopal:		.asciiz	"No es un palindromo"
text3:		.asciiz	"Su contraseña es:"
		.text
main:		la	$a0,text1		#carga la direccion de text1
		li	$v0,4			#instruccion de imprimir string
		syscall				#imprime
		la	$a0,palindromo 		#carga la direcion de palindromo
		li	$v0,8			#instruccion de leer un string
		li	$a1,1024		#argumento de leer un string (guarda en a1 el string de tamaño 1024)
		syscall				#leo la frase
		li	$s0,0			#inicializo s0 como 0
		sb	$s0,verificar		#Guardo el byte de s0 en verificar
		jal 	print			#salto a la etiqueta print
		la 	$a0,palindromo		#carga la direccion de palindromo
		lb	$t0,palindromo		#carga 1 byte de memoria de palindromo 
		li	$t3,0			#auxiliar para encontrar ultimo registro
		lb 	$t4,fin_palindromo	#cargo 1 byte de memoria de fin_palindromo que seria \n
		jal 	fin			#salto a la etiqueta fin
		add	$s5,$zero,$t3		#Guardo en el registro s5 el valor del largo de la palabra
		jal	ver_palindromo		#Salto a la funcion ver_palindromo
		lb 	$t0,verificar
		beq	$t0,1,si_pal
		j	no_pal
		### funciones
si_pal:		j	start
no_pal:		la	$a0,nopal		
		li	$v0,4			#instruccion de imprimir string
		syscall
		li	$v0,10			#system call for exit
		syscall				#end of program
print:		la	$a0,text2		#carga la direccion de text2
		li	$v0,4			#instruccion de imprimir string
		syscall				#imprime
		la	$a0,palindromo		#carga la direccion de palindromo	
		li	$v0,4			#instruccion de imprimir string de palindromo
		syscall				#imprime string	
		jr 	$ra			#devuelve el registro de la siguiente instruccion antes del jal
fin:		lb	$t2,palindromo($t3)	#Cargo un byte, copio en t2 el contador que tengo en t3
		addi	$t3,$t3,1		#Avanzo el contador t3 en 1
		bne	$t2,$t4,fin		#salto condicional, salta a etiqueta si t2 es distinto a t4
		addi	$t3,$t3,-2		#Guardo la ultima letra antes del \n, ya que el contador me avanzara un byte mas que el espacio
		lb 	$t1,palindromo($t3)	#Guardo en t1 el byte de la ultima letra
		li	$t2,0			#Dejo el t2 en 0
		jr	$ra			#devuelvo el registro de la siguiente instruccion cuando se llamo el jal
ver_palindromo:	lb	$t0,palindromo($t2)	#Guardo en t0 la primera letra por la izq
		lb	$t1,palindromo($t3)	#Guardo en t1 la primera letra por la derecha
		bge 	$t2,$t3,ver		#Si t2 es mayor o igual a t3 llama a la etiqueta ver
		beq	$t0,32,espacio_i	#Salta uno a la derecha si encuentra un espacio (31 codigo ascii del espacio)		
		beq	$t1,32,espacio_d	#Salta uno a la izquierda si hay un espacio
		addi	$t2,$t2,1		#Avanza en 1 el t2
		addi	$t3,$t3,-1		#Avanza en -1 el t3 
		beq	$t0,$t1,ver_palindromo	#Compara t0 con t1 y si son iguales llama a la etiqueta ver_palindromo
		jr	$ra			#Manda a la direccion de memoria guardada en $ra
espacio_i:	addi	$t2,$t2,1		#Avanza en 1 el t2
		b	ver_palindromo		#hace un back a la etiqueta ver_palindromo
espacio_d:	addi	$t3,$t3,-1		#Avanza en -1 el t3
		b	ver_palindromo		#Hace un back a la etiqueta ver_palindromo
ver:		li	$s0,1			#guarda en s0 el valor 
		sb	$s0,verificar		#Guarda 1 byte de s0 dentro de verificar
		li	$s0,0			#deja el s0 con el valor 0
		jr 	$ra			#llama de vuelta a la siguiente instruccion guardada en ra, en la linea 24,despues del jal a ver palindromo
		########################################################
		#s5 =  tamaño
		#t0 = j		#t1 = pos 	#t2 = inicio	#t6 = letra actual
		#t3 = letra	#t4 = cont	#t5 = espacio
start:		li 	$t0,0 			#inicializo t0 como 0
		li	$t1,0			#inicializo t1 como 0
		li	$t2,0			#inicializo t2 como 0
		lb	$t5,espacio
		jal 	contra			#primer while
		la	$a0,text3		
		li	$v0,4			#instruccion de imprimir string de palindromo
		syscall				#imprime string	
		la	$a0,contras			
		li	$v0,4			#instruccion de imprimir string de palindromo
		syscall				#imprime string	
		li	$v0,10			#system call for exit
		syscall				#end of program
contra:		add	$t2,$zero,$t0
		lb 	$t3,palindromo($t2)	
		li 	$t4,0
		beq	$t3,$t5,salto2		#beq, letra = espacio
		ble	$t0,$s5,loop1 		#ble, es j <= tamaño		
		jr 	$ra
loop1:		lb 	$t6,palindromo($t2)
		beq	$t6,$t5,salto
		beq 	$t6,$t3,if		# beq, es = , letra actual y letra buscada
		addi	$t2,$t2,1
		ble	$t2,$s5,loop1
		j	guardar		
if:		addi	$t4,$t4,1
		sb 	$t5,palindromo($t2)
		addi	$t2,$t2,1
		b 	loop1
salto:		addi	$t2,$t2,1
		b	loop1
guardar:	addi	$t4,$t4,48
		sb	$t4,contras($t1)
		addi	$t1,$t1,1
		sb	$t3,contras($t1)
		addi	$t1,$t1,1
		addi	$t0,$t0,1
		j	contra	
salto2:		addi	$t0,$t0,1
		b	contra