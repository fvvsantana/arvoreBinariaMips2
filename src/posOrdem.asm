.data
	newline: .asciiz "\n"
.text
	.globl posOrdem
	posOrdem:	
		#Coloca no resistrador s1 o endereco da raiz da arvore
		lw $s1, 0($a0)
		
		#Coloca em a1 o endereco da raiz da arvore
		move $a1, $s1
		
		pos:
			#Desloca o stack pointer
			sub $sp, $sp, 4
		
			#Armazena o endereco de fp atual na stack
			sw $fp, 0($sp)
		
			#Atualiza fp para o local aonde esta armazenado o fp da chamada anterior
			move $fp, $sp
		
			#Desloca o stack pointer em duas posicoes
			sub $sp, $sp, 8
		
			#Salva o endereco da raiz no registrador s1
			move $s1, $a1
		
			#Armazena os enderecos de retorno e da arvore na stack
			sw $ra, -4($fp)
			sw $s1, -8($fp)
						
			#Coloca em a1 o endereco do no esquerdo
			lw $a1, 4($s1)
			
			#Verifica se ha no esquerdo. Caso negativo, procura no direito
			beq $a1, -1, direita
			
			#Caso positivo, procura por filhos do no esquerdo
			jal pos
		
		direita:
			
			#Carraga em s1 o endereco do elemento da direita
			lw $a1, 8($s1)
			
			#Se nao existir no direito, printa e volta a execucao anterior
			beq $a1, -1, retorna
			
			#Caso exista no direito, faz a procura de seus filhos
			jal pos
			
		retorna:
			
			
			#Imprime o elemento da arvore
			lw $a0, 0($s1)
			li $v0, 1
			syscall
			
			#Imprime um newline
			la $a0, newline
			li $v0, 4
			syscall
			
			#Faz o stack pointer apontar para o inicio da pilha da execucao atual
			move $sp, $fp
			
			#Coloca em ra o endereco aonde a execucao anterior parou
			lw $ra, -4($fp)
			
			#Atualiza fp para o inicio da stack da execucao anterior
			lw $fp, 0($sp)
			
			#Carrega em s1 o endereco da raiz da execucao anterior
			lw $s1, -8($fp)
			
			#Desloca o stack pointer para o ultimo elemento da pilha
			add $sp, $sp, 4
			
			#Retorna para o ponto de onde parou na execucao anterior
			jr $ra
			