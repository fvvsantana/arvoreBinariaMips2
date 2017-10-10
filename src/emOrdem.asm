.data
	titulo:	 .asciiz "\nEm ordem:\n"
	virgula: .asciiz ","
	ponto:	 .asciiz "."

.text
	.globl emOrdem
	
	emOrdem:#(No* algum)
	
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
		recursao:
			# se o no atual estiver vazio, pular para o final
			beq $a0, -1, finalizar
	
			# salva o endereco de retorno
			sub $sp, $sp, 4
			sw $ra, 0($sp)
		
			# salva o endereco desse no ($a0) antes de chamar a proxima funcao
			sub $sp, $sp, 4
			sw $a0, 0($sp)
		
			# chama a funcao para o no da esquerda
			lw $a0, 4($a0)
			jal recursao
			
			# recupera o endereco desse no
			lw $t0, 0($sp)
			add $sp, $sp, 4
		
			# imprime o valor desse no
		 	lw $a0, 0($t0)
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
	 	
		 	# chama a funcao para o no da direita
		 	lw $a0, 8($t0)
	 		jal recursao
		
			# recupera o endereco de retorno
			lw $ra, ($sp)
			add $sp, $sp, 4
		
			finalizar:
			jr $ra
