.data
	newline: .asciiz "\n"
.text
	.globl posOrdem
	
		posOrdem:			
			#Aloca memoria para receber dados da execucao atual
			sub $sp, $sp, 12
		
			#Armazena o endereco de fp atual na stack
			sw $fp, 8($sp)
		
			#Atualiza fp para o local aonde esta armazenado o fp da chamada anterior
			add $fp, $sp, 8
		
			#Armazena os enderecos de retorno e do no na stack
			sw $ra, -4($fp)
			sw $a0, -8($fp)
			
			#Verifica se o endereco analizado atualmente e invalido
			#Caso afirmativo, termina a execução
			beq $a0, -1, return
			
			#Coloca em a0 o endereço do no esquerdo e executa o percorrimento
			lw $a0, 4($a0)
			jal posOrdem
			
			#Carrega em a0 o endereco da raiz da execucao atual
			lw $a0, -8($fp)
			
			#Coloca em a0 o endereço do no direito e executa o percorrimento
			lw $a0, 8($a0)
			jal posOrdem
			
			#Carrega em a0 o endereco da raiz da execucao atual
			lw $a0, -8($fp)
			
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
			lw $ra, -4($fp)
			
			#Atualiza o valor de fp para o valor da execução anterior
			lw $fp, 0($fp)
			
			#Desaloca memória da execução anterior
			add $sp, $sp, 8
			
			#Retorna para o ponto de onde parou na execucao anterior
			jr $ra