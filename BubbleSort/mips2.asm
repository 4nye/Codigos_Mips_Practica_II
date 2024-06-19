

.data
msg:    .asciiz "los elementos ordenados de forma ascendente son:"
        .align 2        
space:  .asciiz " "
            .align 2        
comma:  .asciiz ","
            .align 2       
arr:        .space 80       # el maximo del arreglo sera= 20 * 4 bytes 
.text

main:   

    # Pide al usuario que ingrese la cantidad de numeros a leer y lo almacena en $s1
    addi $v0, $zero, 5     
    syscall             
    add $s1, $zero, $v0         # Almacena la longitud en $s1

    # Carga la direcci�n del arreglo
    la $s0, arr             # carga la direcci�n de arr en $s0

    add $a0, $zero, $s0     # almacena la direcci�n de arr en $a0
    add $a1, $zero, $s1     # almacena la longitud en $a1

    # Llena la matriz con valores ingresados por el usuario
    jal llenar            

    # Ordena la lista utilizando selecci�n
    jal ordenar            

    # Imprime la lista
    jal print          

    # Termina el programa
    addi $v0, $zero, 10         # llama al servicio 10 para salir
    syscall             # sale del programa


llenar:   
    addi $sp, $sp, -8       # reserva espacio en la pila
    sw $s0, 0($sp)          # almacena $s0 (posici�n) en la pila
    sw $s1, 4($sp)          # almacena $s1 (entrada) en la pila
    addi $t0, $zero, 0      # $t0 = 0
    add $s0, $zero, $t0     # inicializa $s0 = $t0 = 0

llenar_bucle:
    slt $t1, $s0, $a1       # si (posici�n < longitud) contin�a
    beq $t1, $zero, llenar_return     # si (posici�n >= longitud) sale del bucle

    addi $v0, $zero 5       # llama al servicio 5 para leer un entero
    syscall             # lee un entero

    addi $s1, $zero, 0      # limpia $s1 y lo establece en 0
    add $s1, $zero, $v0         # $s1 almacena el entero le�do

    add $t3, $zero, $s0         # $t3 = posici�n
    sll $t3, $t3, 2         # $t3 = posici�n * 4
    add $t3, $t3, $a0       # direcci�n de arr[posici�n]
    sw $s1, 0($t3)          # almacena el valor $s1 en arr[posici�n]

    addi $s0, $s0, 1        # posici�n++

    j   llenar_bucle       

llenar_return:
    lw $s0, 0($sp)          # restaura $s0 de la pila
    lw $s1, 4($sp)          # restaura $s1 de la pila
    addi $sp, $sp 8         # ajusta el puntero de la pila
    jr $ra                  # regresa



ordenar:
    addi $sp, $sp, -28      # reserva espacio en la pila
    sw $a0, 0($sp)          # almacena $a0 (arreglo) en la pila
    sw $a1, 4($sp)          # almacena $a1 (longitud) en la pila
    sw $ra, 8($sp)          # almacena la direcci�n de regreso en la pila
    sw $s0, 12($sp)         # almacena $s0 (�ndice i) en la pila
    sw $s1, 16($sp)         # almacena $s1 (�ndice j) en la pila
    sw $s2, 20($sp)         # almacena $s2 (temporal) en la pila
    sw $s3, 24($sp)         # almacena $s3 (�ndice m�nimo) en la pila

    addi $s0, $zero, 0      # i = 0
    add $t0, $zero, $a1     # $t0 = longitud
    addi $t0, $t0, -1       # $t0 = longitud - 1

for_1:
    slt $t1, $s0, $t0       # si (i < longitud - 1) contin�a
    beq $t1, $zero, ordenar_return     # si (i >= longitud - 1) sale del bucle

    add $s3, $zero, $s0         # �ndice m�nimo = i
    addi $t1, $s0, 1        # $t1 = i + 1
    add $s1, $zero, $t1         # j = $t1 = i + 1

for_2: 
    slt $t1, $s1, $a1       # si (j < longitud) contin�a
    beq $t1, $zero, if_1        # si (j >= longitud) sale del bucle 
    
if_2: # para buscar el minimo

    # obtenemos el valor en arr[ j ] y almacenarlo en $t3
    add $t2, $zero, $s1         # calcular �ndice $t2 = j 
    sll $t2, $t2, 2         # offset = $t2 * 4
    add $t2, $t2, $a0       # agregar offset a la direcci�n base
    lw $t3, 0($t2)          # cargar valor en arr[ j ] en $t3

    # obtenemos el valor en arr[minIndex] y almacenarlo en $t5
    add $t4, $zero, $s3         # calcular �ndice $t4 = minIndex
    sll $t4, $t4, 2         # offset = $t4 * 4
    add $t4, $t4, $a0       # agregar offset a la direcci�n base
    lw $t5, 0($t4)          # cargar valor en arr[min] en $t5

    slt $t1, $t3, $t5       # si(arr[ j ] < arr[minIndex]) contin�a
    beq $t1, $zero, bucle_2      # si(arr[ j ] >= arr[min]) sale de la sentencia if
    add $s3, $zero, $s1         # min = j

bucle_2:
    addi $s1, $s1, 1        # j++
    j for_2

if_1: # "swap"
    beq $s3, $s0, bucle_1        # si(min == i) salta fuera de la sentencia if (salta a bucle_1)

    # tmp = arr[minIndex]
    add $t2, $zero, $s3         # calcular �ndice $t2 = minIndex
    sll $t2, $t2, 2         # offset = $t2 * 4
    add $t2, $t2, $a0       # agregar offset a la direcci�n base
    lw $s2, 0($t2)          # $s2 = tmp = arr[min]

    # arr[minIndex] = arr[ i ]
    add $t3, $zero, $s0         # calcular �ndice $t3 = i
    sll $t3, $t3, 2         # offset = $t2 * 4
    add $t3, $t3, $a0       # agregar offset a la direcci�n base
    lw $t6, 0($t3)          # $t6 = arr [ i ]

    sw $t6, 0($t2)          # almacenar valor en arr[ i ] en arr[min] 

    # arr[ i ] = tmp
    sw $s2, 0($t3)          # almacenar valor tmp en arr[ i ]           

bucle_1:
    addi $s0, $s0, 1        # i++
    j for_1 

ordenar_return:
    lw $a0, 0($sp)          # restaurar $a0 desde la pila
    lw $a1, 4($sp)          # restaurar $a1 desde la pila
    lw $ra, 8($sp)          # restaurar direcci�n de retorno desde la pila
    lw $s0, 12($sp)         # restaurar $s0 desde la pila
    lw $s1, 16($sp)         # restaurar $s1 desde la pila
    lw $s2,  20($sp)        # restaurar $s2 desde la pila
    lw $s3, 24($sp)         # restaurar $s3 desde la pila
    addi $sp, $sp 28        # ajustar puntero de pila
    jr $ra              # regresar



print:
    addi $sp, $sp, -4       # hacer espacio en la pila
    sw $s0, 0($sp)          # guardar $s0 (posici�n) en la pila
    addi $t0, $zero, 0      # $t0 = 0
    add $s0, $zero, $t0     # inicializar $s0 = $t0 = 0

    # imprimir mensaje
    la $s3, msg         # cargar direcci�n de msg en $s3
    add $a0, $zero, $s3         # poner direcci�n de msg en $a0 para imprimir
    addi $v0, $zero, 4      # llamar servicio 4 para imprimir cadena
    syscall             # imprimir cadena

    # imprimir espacio
    la $s3, space           # cargar direcci�n de espacio en $s3
    add $a0, $zero, $s3         # poner direcci�n de espacio en $a0 para imprimir
    addi $v0, $zero, 4      # llamar servicio 4 para imprimir cadena
    syscall             # imprimir cadena

print_bucle:
    slt $t2, $s0, $a1       # si(posici�n < longitud) continuar
    beq $t2, $zero, print_return    # si(posici�n >= longitud) salir del bucle 

    la $a0, arr             # recargar puntero de arreglo en $a0

    add $t3, $zero, $s0         # $t3 = posici�n
    sll $t3, $t3, 2         # $t3 = posici�n * 4
    add $t3, $t3, $a0       # $t3 = direcci�n de arr[posici�n]

    lw $t4, 0($t3)          # Cargar valor para imprimir
    add $a0, $zero, $t4         # poner direcci�n de $t4 en $a0 para imprimir

    addi $v0, $zero, 1      # llamar servicio 1 para imprimir entero
    syscall             # imprimir entero

    # Verificar si es el �ltimo elemento del arreglo
    # Saltar imprimir coma y espacio
    addi $t3, $a1, -1       # $t3 = longitud - 1
    beq $t3, $s0, print_return  # si(estamos en el �ltimo elemento)

    # imprimir coma
    la $s3, comma           # cargar direcci�n de coma en $s3
    add $a0, $zero, $s3         # poner direcci�n de coma en $a0 para imprimir
    addi $v0, $zero, 4      # llamar servicio 4 para imprimir cadena
    syscall             # imprimir cadena

    # imprimir espacio
    la $s3, space           # cargar direcci�n de espacio en $s3
    add $a0, $zero, $s3         # poner direcci�n de espacio en $a0 para imprimir
    addi $v0, $zero, 4      # llamar servicio 4 para imprimir cadena
    syscall             # imprimir cadena

    addi $s0, $s0, 1        # posici�n++

    j print_bucle

print_return:
    lw $s0, 0($sp)          # restaurar $s0 desde la pila
    addi $sp, $sp 4         # ajustar puntero de pila
    jr $ra              # regresar