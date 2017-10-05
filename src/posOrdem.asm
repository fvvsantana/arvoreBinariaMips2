.data
	newline: .asciiz "\n"
.text
	.globl posOrdem
	
		posOrdem:			
			#Aloca memoria para receber dados da execucao atual
			sub $sp, $sp, 8
		
			#Armazena o endereco de retorno e do no na stack
			sw $a0, 0($sp)
			sw $ra, 4($sp)
			
			#Verifica se o endereco analizado atualmente e invalido
			#Caso afirmativo, termina a execução
			beq $a0, -1, return
			
			#Coloca em a0 o endereço do no esquerdo e executa o percorrimento
			lw $a0, 4($a0)
			jal posOrdem
			
			#Carrega em a0 o endereco da raiz da execucao atual
			lw $a0, 0($sp)
			
			#Coloca em a0 o endereço do no direito e executa o percorrimento
			lw $a0, 8($a0)
			jal posOrdem
			
			#Carrega em a0 o endereco da raiz da execucao atual
			lw $a0, 0($sp)
			
			#Imprime o elemento da arvore
			lw $a0, 0($a0)
			li $v0, 1
			syscall
			
			#Imprime um newline
			la $a0, newline
			li $v0, 4
			syscall
			
		return:
			#Coloca em ra o endereco de aonde a execucao anterior parou
			lw $ra, 4($sp)
			
			#Desaloca memória da execução anterior
			add $sp, $sp, 8
			
			#Retorna para o ponto de onde parou na execucao anterior
			jr $ra