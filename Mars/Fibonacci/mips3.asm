# Reservamos los datos a usar 
.data

fibs:.word   0 : 19         #  declaramos un arreglo de tipo word para contener los valores de fib
size: .word  19             # y en simultaneo el tama�o de dicho arreglo (debe coincincidir con la declaraci�n del arreglo)
prompt: .asciiz "�Cu�ntos n�meros de Fibonacci desea generar? (2 <= x <= 19)"

.text
      la   $s0, fibs        # Cargamow la direcci�n del arreglo en $s0
      la   $s5, size        # Cargamos la direcci�n del tama�o del arreglo en $s5
      lw   $s5, 0($s5)      # Para finalmente cargar el tama�o del arreglo

# Opcional: el usuario ingresa el n�mero de n�meros de Fibonacci a generar
#pr:   la   $a0, prompt      # Carga la direcci�n del prompt para el syscall
#      li   $v0, 4           # Especifica el servicio Print String
#      syscall               # Imprime la cadena de texto del prompt
#      li   $v0, ?????Reemplaza_esto_con_el_valor_num�rico_correcto???????           # Especifica el servicio Read Integer
#      syscall               # Lee el n�mero. Despu�s de esta instrucci�n, el n�mero le�do est� en $v0.
#      bgt  $v0, $s5, pr     # Comprueba el l�mite del input del usuario -- si es inv�lido, reinicia
#      blt  $v0, $zero, pr   # Comprueba el l�mite del input del usuario -- si es inv�lido, reinicia
#      add  $s5, $v0, $zero  # Transfiere el n�mero al registro deseado
      
      li   $s2, 1           # 1 es el valor conocido del primer y segundo n�mero de Fibonacci
      sw   $s2, 0($s0)      # F[0] = 1
      sw   $s2, 4($s0)      # F[1] = F[0] = 1
      addi $s1, $s5, -2     # Contador para el bucle, se ejecutar� (tama�o-2) veces
      
      # Bucle para calculara cada n�mero de Fibonacci usando los dos n�meros de Fibonacci anteriores.
loop: lw   $s3, 0($s0)      # Obtiene el valor del arreglo F[n-2]
      lw   $s4, 4($s0)      # Obtiene el valor del arreglo F[n-1]
      add  $s2, $s3, $s4    # F[n] = F[n-1] + F[n-2]
      sw   $s2, 8($s0)      # Almacena el nuevo F[n] en el arreglo
      addi $s0, $s0, 4      # Incrementa la direcci�n al siguiente n�mero de Fibonacci conocido
      addi $s1, $s1, -1     # Decrementa el contador del bucle
      bgtz $s1, loop        # Repite mientras no haya terminado
      
      # Los n�meros de Fibonacci se han calculado y almacenado en el arreglo. Imprime los n�meros.
      la   $a0, fibs        # Primer argumento para imprimir (arreglo)
      add  $a1, $zero, $s5  # Segundo argumento para imprimir (tama�o)
      jal  print            # Llama a la rutina de impresi�n.

      # El programa ha terminado. Salir.
      li   $v0, 10          # N�mero de sistema para salir
      syscall              