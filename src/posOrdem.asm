.data
	comma: .asciiz ", "
	dot: .asciiz ".\n"
.text
	.globl posOrdem
	
		posOrdem:
			#Verifica se o endereco analizado atualmente e invalido
			#Caso afirmativo, termina a execução
			beq $a0, -1, exit
			
			#Aloca um espaço na stack		
			sub $sp, $sp, 4
			
			#Salva o antigo valor de fp na stack
			sw $fp, 0($sp)
			
			#Atualiza o valor de fp
			move $fp, $sp
			
			j do
			
			exec:
				#Verifica se o endereco analizado atualmente e invalido
				#Caso afirmativo, termina a execução
				bne $a0, -1, do
			
				#Retorna para a execução anterior
				j exit
			
			do:
				
				#Aloca memoria para receber dados da execucao atual
				sub $sp, $sp, 8
		
				#Armazena o endereco de retorno e do no na stack
				sw $a0, 0($sp)
				sw $ra, 4($sp)
			
				#Coloca em a0 o endereço do no esquerdo e executa o percorrimento
				lw $a0, 4($a0)
				jal exec
			
				#Carrega em a0 o endereco da raiz da execucao atual
				lw $a0, 0($sp)
			
				#Coloca em a0 o endereço do no direito e executa o percorrimento
				lw $a0, 8($a0)
				jal exec
			
				#Carrega em a0 o endereco da raiz da execucao atual
				lw $a0, 0($sp)
			
				#Imprime o elemento da arvore
				lw $a0, 0($a0)
				li $v0, 1
				syscall
			
				#Coloca em ra o endereco de aonde a execucao anterior parou
				lw $ra, 4($sp)
			
				#Desaloca memória da execução anterior
				add $sp, $sp, 8
				
				beq $sp, $fp, printDot
				
				#Imprime a virgula
				la $a0, comma
				li $v0, 4
				syscall
				
				#Retorna para o ponto de onde parou na execucao anterior
				j exit
				
			printDot:
				#Imprime o ponto
				la $a0, dot
				li $v0, 4
				syscall
					
				#Volta o valor de fp da main
				lw $fp, 0($sp)
					
				#Desaloca meoria da stack
				add $sp, $sp, 4
			
			exit:
				#Retorna para o ponto de onde parou na execucao anterior
				jr $ra
