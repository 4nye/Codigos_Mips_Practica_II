	.data
mensaje:	.asciiz		"Arreglo ordenado: ["
espacio:		.asciiz		", "
corchete:	.asciiz		"]"
c: 		.word 0:100             

numeros:	.word 56,3,46,47,34,12,1,5,10,8,33,25,29,60,50,43
	.text

main:	
	la $a0, numeros		# Cargamos la direccion del vector a $a0
	
	                        #establecemos los bordes 
	addi $a1, $zero, 0 	# $a1 = low	
	addi $a2, $zero, 15 	# $a2 = high
	jal mergesort		 
	
	la  $a0, mensaje 	# imprimimos la notificacion declarada
	li  $v0, 4		
	syscall     		
	
	jal Print		# posteriormente imprimimos el arreglo
	la  $a0, corchete	
	li  $v0, 4		
	li  $v0, 10		
	syscall
	
mergesort: 
	slt $t0, $a1, $a2 	# si low < high entoncess $t0 = 1 sino $t0 = 0  
	beq $t0, $zero, return	# s $t0 = 0, ve a return
	addi, $sp, $sp, -16 	# reservamos esoacio en la pila 
	sw, $ra, 12($sp)	# y guardamos la direccion de retorno
	sw, $a1, 8($sp)	       	# guardamos el valor de low en $a1
	sw, $a2, 4($sp)        	# y el valor de high en $a2

	add $s0, $a1, $a2	# mid = low + high
	sra $s0, $s0, 1		# mid = (low + high) / 2
	sw $s0, 0($sp) 		# guardamos el valor que se considerara como el medio en $s0
				
	add $a2, $s0, $zero 	# hacemos que high = mid para ordenar la primera mitad del vector
	jal mergesort		# y llamamos recursivamente 
	
	lw $s0, 0($sp)		# cargamos el valor del medio guardado en la pila 
	addi $s1, $s0, 1	# y almacenamos mid + 1 en $s1
	add $a1, $s1, $zero 	# ahora hacemos low = mid + 1 para ordenar la segunda mitad del vector
	lw $a2, 4($sp) 		# cargamos el valor de high guardado en la pila
	jal mergesort 		# volvemos a llamar recursivamente
	
	lw, $a1, 8($sp) 	# cargamos los valores de high y low de la pila 
	lw, $a2, 4($sp)  	
	lw, $a3, 0($sp) 	# y de igual forma cargamos mid de la pila hacia $a3 que sera un argumento importante para la funcion merge
	jal merge	
				
	lw $ra, 12($sp)		#restablecemos la pila 
	addi $sp, $sp, 16 	
	jr  $ra

return:
	jr $ra 			
	
merge:
	add  $s0, $a1, $zero 	# $s0 = i; i = low
	add  $s1, $a1, $zero 	# $s1 = k; k = low
	addi $s2, $a3, 1  	# $s2 = j; j = mid + 1

while1: 
	blt  $a3,  $s0, while2	# si mid < i entonces entra al siguiente bucle While 
	blt  $a2,  $s2, while2	# si high < j entonces entra al siguiente bucle While 
	j  if			# si i <= mid y j <=high
	
if:
	sll  $t0, $s0, 2	# $t0 = i*4
	add  $t0, $t0, $a0	# suma la direccion de a[0]; resultando ahora que $t2 = direccion de a[i]
	lw   $t1, 0($t0)	# carga el valor en  a[i] en $t1
	sll  $t2, $s2, 2	# $t1 = j*4
	add  $t2, $t2, $a0	# nuevamente suma la direccion de a[0]; resultando nuevamente en $t2 = direccion de a[j]
	lw   $t3, 0($t2)	# carga el valor de a[j] en $t3	
	blt  $t3, $t1, else	# si a[j] < a[i], entonces ve al Else
	la   $t4, c		# obtenemos la direccion de inicio de c en $t4
	sll  $t5, $s1, 2	# k*4
	add  $t4, $t4, $t5	# $t4 = c[k]; 
	sw   $t1, 0($t4)	# c[k] = a[i]
	addi $s1, $s1, 1	# k++
	addi $s0, $s0, 1	# i++
	j    while1		
	
else:
	sll  $t2, $s2, 2	# $t1 = j*4
	add  $t2, $t2, $a0	# nuevamente volvemos a sumar a[0]; $t2 = direccion de a[j]
	lw   $t3, 0($t2)	# $t3 = se le asigna lo que sea que este en a[j]	
	la   $t4, c		# extraemos la direccion de c en $t4
	sll  $t5, $s1, 2	# k*4
	add  $t4, $t4, $t5	# $t4 = c[k]; 
	sw   $t3, 0($t4)	# c[k] = a[j]
	addi $s1, $s1, 1	# k++
	addi $s2, $s2, 1	# j++
	j    while1		
	
while2:
	blt  $a3, $s0, while3 	# si mid < i
	sll $t0, $s0, 2		# $t6 = i*4
	add $t0, $a0, $t0	# suma la direccion de a[0]; ahora $t6 = direccion de a[i]
	lw $t1, 0($t0)		# cargamos el valor de [i] en $t7
	la  $t2, c		# inicializamos la direccion de c en $t2 
	sll $t3, $s1, 2         # k*4
	add $t3, $t3, $t2	# $t3 = c[k]; 
	sw $t1, 0($t3) 		# guardamos el valor de $t7 como la direccion $t5, cual seria c[k]
	addi $s1, $s1, 1   	# k++
	addi $s0, $s0, 1   	# i++
	j while2		
	

while3:
	blt  $a2,  $s1, forI	#si high < j entonces entra al bucle For 
	sll $t2, $s2, 2    	# $t6 = j*4
	add $t2, $t2, $a0  	# suma la direccion de a[0]; ahora $t6 = la direccion de a[j]
	lw $t3, 0($t2)     	# $t7 = el valor guardado en a[j]
	
	la  $t4, c		# se carga la direccion de c
	sll $t5, $s1, 2	   	# k*4
	add $t4, $t4, $t5  	# $t5 = c[k]; $t4 es la direccion de c[k]
	sw $t3, 0($t4)     	# $t4 = c[k]; 
	addi $s1, $s1, 1   	# k++
	addi $s2, $s2, 1   	# j++
	j while3		

forI:
	add  $t0, $a1, $zero	# initialize $s5 to low for For loop
	addi $t1, $a2, 1 	# initialize $t3 to high+1 for For loop
	la   $t4, c		# load the address of array c into $s7	
	j    for
for:
	slt $t7, $t0, $t1  	# $t4 = 1 si $s5 < $s2
	beq $t7, $zero, shortEnd	# si $t4 = 0, ve a shortEnd
	sll $t2, $t0, 2   	# $s5 * 4 
	add $t3, $t2, $a0	# sumamos el las direcciones para obtener a => a[$t7]
	add $t5, $t2, $t4	# de igual manera lo hacemos aca con c => c[$t5]
	lw  $t6, 0($t5)		# cargamos el valor de c[i] en $t6
	sw $t6, 0($t3)   	# guardamos el valor de c[$t0] en a[$t0]; para que a[i] = c[i]
	addi $t0, $t0, 1 	# incrementamos el valor de $t0 en 1 para llevar control del bucle for
	j for 			

shortEnd:
	jr $ra			
Print:
	add $t0, $a1, $zero 	# inicializamos $t0 como low
	add $t1, $a2, $zero	# y inicializamos $t1 como high
	la  $t4, numeros	#  cargamos la direccion del vector en $t4
	
Print_Loop:
	blt  $t1, $t0, Exit	# si $t1 < $t0, ve a la funcion Exit
	sll  $t3, $t0, 2	# $t0 * 4 
	add  $t3, $t3, $t4	# sumamos las direcciones para obtener array[$t3]
	lw   $t2, 0($t3)	# cargamos el valor de y[$t0] en $t2
	move $a0, $t2		# movemos el valor a $a0 para poder imprimirlo 
	li   $v0, 1		
	syscall
	
	addi $t0, $t0, 1	# incrementa $t0 en 1 para el bucle 
	la   $a0, espacio	# marca la separacion entre los numeros
	li   $v0, 4		
	syscall
	j    Print_Loop		
	
Exit:
	jr $ra			# salta para regresar al main
	
