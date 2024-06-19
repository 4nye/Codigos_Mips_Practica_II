.data
data: .word 0 : 256       # Almacenamiento para una matriz de 16x16 de palabras
.text
      li       $t0, 16        # $t0 = n�mero de filas
      li       $t1, 16        # $t1 = n�mero de columnas
      move     $s0, $zero     # $s0 = contador de filas
      move     $s1, $zero     # $s1 = contador de columnas
      move     $t2, $zero     # $t2 = valor a almacenar

# Cada iteraci�n del bucle almacenar� el valor incrementado de $t1 en el siguiente elemento de la matriz.
# Se calcula el desplazamiento en cada iteraci�n. Desplazamiento = 4 * (fila*#columnas + columna)
# Nota: no se hace ning�n intento de optimizar el rendimiento de tiempo de ejecuci�n.
loop:    mult     $s0, $t1       # $s2 = fila * #columnas  (secuencia de dos instrucciones)
         mflo     $s2            # mueve el resultado de la multiplicaci�n desde el registro lo a $s2
         add      $s2, $s2, $s1  # $s2 += contador de columnas
         sll      $s2, $s2, 2    # $s2 *= 4 (desplazamiento a la izquierda de 2 bits) para desplazamiento de bytes
         sw       $t2, data($s2) # almacena el valor en el elemento de la matriz
         addi     $t2, $t2, 1    # incrementa el valor a almacenar

# Control de bucle: Si se incrementa m�s all� de la �ltima columna, se restablece el contador de columnas y se incrementa el contador de filas
#                Si se incrementa m�s all� de la �ltima fila, hemos terminado.
         addi     $s1, $s1, 1    # incrementa el contador de columnas
         bne      $s1, $t1, loop # no estamos al final de la fila, as� que volvemos a bucle
         move     $s1, $zero     # restablece el contador de columnas
         addi     $s0, $s0, 1    # incrementa el contador de filas
         bne      $s0, $t0, loop # no estamos al final de la matriz, as� que volvemos a bucle

# Hemos terminado de recorrer la matriz.
         li       $v0, 10        # servicio de sistema 10 es salir
         syscall                 # hemos terminado.