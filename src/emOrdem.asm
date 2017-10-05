.data
	newline: .asciiz "\n"

.text
	.globl emOrdem
	emOrdem:#(No* algum)
		
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
		jal emOrdem
		
		# recupera o endereco desse no
		lw $t0, 0($sp)
		add $sp, $sp, 4
		
		# imprime o valor desse no
	 	lw $a0, 0($t0)
	 	li $v0, 1
	 	syscall
	 	
	 	# imprime newline
		li $v0, 4
		la $a0, newline
		syscall
	 	
	 	# chama a funcao para o no da direita
	 	lw $a0, 8($t0)
	 	jal emOrdem
		
		# recupera o endereco de retorno
		lw $ra, ($sp)
		add $sp, $sp, 4
		
		finalizar:
		jr $ra