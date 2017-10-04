.data
	newline: .asciiz "\n"
.text
	.globl posOrdem
	posOrdem:	
		#Coloca no resistrador s0 o endere�o da raiz da arvore
		lw $s0, 0($a0)
		
		#Coloca em a0 o endere�o da raiz da arvore
		move $a1, $s0
		
		pos:
			#Desloca o stack pointer
			sub $sp, $sp, 4
		
			#Armazena o endere�o de $fp atual na stack
			sw $fp, 0($sp)
		
			#Atualiza o $fp para o local aonde est� armazenado o fp da chamada anterior
			move $fp, $sp
		
			#Desloca o stack pointer em duas posicoes
			sub $sp, $sp, 8
		
			#Salva o endereco da raiz no registrador s0
			move $s0, $a1
		
			#Armazena os enderecos de retorno e da arvore na stack
			sw $ra, -4($fp)
			sw $s0, -8($fp)
						
			#Coloca em a0 o endereco do no esquerdo
			lw $a1, 4($s0)
			
			#Verifica se h� n� esquesdo. Caso negativo, procura n� direito
			beq $a1, -1, direita
			
			#Caro positivo, procura por filhos do n� esquerdo
			jal pos
		
		direita:
			
			#Carraga em s0 o endereco do elementa da direita
			lw $a1, 8($s0)
			
			#Se nao existir n� direito, printa e volta � execucao anterior
			beq $a1, -1, retorna
			
			#Caso exista no direito, faz a procura de seus filhos
			jal pos
			
		retorna:
			
			
			#Imprime o elemento da arvore
			lw $a0, 0($s0)
			li $v0, 1
			syscall
			
			#Imprime um newline
			la $a0, newline
			li $v0, 4
			syscall
			
			#Faz o stack pointer apontar para o inicio da pilha da execucao atual
			move $sp, $fp
			
			#Coloca em ra o endere�o aonde a execucao anterior parou
			lw $ra, -4($fp)
			
			#Atualiza fp para o inicio da stack da execucao anterior
			lw $fp, 0($sp)
			
			#Carrega em s0 o endere�o da raiz da raiz da execu��o anterior
			lw $s0, -8($fp)
			
			#Desloca o stack pointer para o ultimo elemento da pilha
			add $sp, $sp, 4
			
			#Retorna para o ponto de onde parou na execucao anterior
			jr $ra
							
		