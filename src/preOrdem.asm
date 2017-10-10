.data
	titulo:	 .asciiz "\nPre-ordem:\n"
	virgula: .asciiz ","
	ponto:   .asciiz ".\n"

.text
	.globl preOrdem
	
	preOrdem:
		#(No* algum)
	
		# salva o $a0
		move $t0, $a0
		
		# imprime o titulo
		li $v0, 4
		la $a0, titulo
		syscall
		
		# recupera $a0
		move $a0, $t0
		
		# inicia o contador e carrega o tamanho da arvore
		li $t1, 1
		lw $t2, tamanho
		
	# parte recursiva:
	rec:
		
		# if (!$a0) vai para fim
		beq $a0, -1, fim
		
		# else{
		# aloca espaço na stack
		sub $sp, $sp, 4
		# guarda o endereço de retorno
		sw $ra, ($sp)
		
		# aloca espaço na stack
		sub $sp, $sp, 4
		# guarda o nó na pilha
		sw  $a0, ($sp)
		
		# imprime o valor desse no
	 	lw $a0, 0($a0)
	 	li $v0, 1
	 	syscall
 
 		# decide se ira imprimir ponto ou virgula
 		beq $t1, $t2, pont
 		
 		virg:
 			la $a0, virgula
 			addi $t1, $t1, 1
 			j imprime
 		
 		pont:
 			la $a0, ponto
	 			
	 	# imprime o separador
	 	imprime:
			li $v0, 4
			syscall
		
		# recupera o nó
		lw $a0, 0($sp)
		
		# chama a função no nó da esquerda
		lw $a0, 4($a0)
		jal rec
		
		# recupera o nó
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		
		# chama a função no nó da direita
		lw $a0, 8($a0)
		jal rec
				
		# recupera o endereço de retorno
		lw $ra, 0($sp)
		addi $sp, $sp, 4
	
	fim:
		jr $ra
		
	
