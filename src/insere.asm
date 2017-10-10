.data
	newline: .asciiz "\n"
	
	# variavel para armazenar o tamanho da arvore
	.globl tamanho
	tamanho: .word 0
	
.text		
	.globl criaArvore
	criaArvore:#(No** arvore)
		#inicializa o ponteiro para o no raiz, apontando-o para NULL (-1)
		li $t0, -1
		sw $t0, ($a0)
		jr $ra
	
	.globl insere
	insere:#(int elem, No** arvore)
	
		#salva o endereco de retorno
		sub $sp, $sp, 4
		sw $ra, ($sp)
		 
		#if(a arvore esta vazia), ou seja, (raiz == -1)
			lw $t0, ($a1)
			bne $t0, -1, else
			
			#salva $a0 para fazer syscall
			move $t0, $a0
			
			#aloca na heap um no do tipo:
			#typedef struct{
			#	int elem;
			#	No* filhoEsq;
			#	No* filhoDir;
			#} No;
			li $a0 12 #12 bytes
			li $v0 9 #syscall 9 (sbrk)
			syscall
			
			#retorma $a0 depois de fazer syscall
			move $a0, $t0
			
			#inicializa no
			sw $a0, ($v0) #elem = $a0
			li $t0, -1
			sw $t0, 4($v0) #filhoEsq = -1
			sw $t0, 8($v0) #filhoDir = -1
			
			#atualiza o tamanho da arvore
			lw $t0, tamanho
			addi $t0, $t0, 1
			sw $t0, tamanho
				 
			#aponta raiz para o no alocado
			sw $v0, ($a1)
			j then
		else:
			#if(no < raiz->elem), ou seja, se o elemento a ser inserido for
			# menor que o elemento do no raiz
				lw $t0, ($a1) #$t0 = raiz
				lw $t1, ($t0) #$t1 = raiz->elem
				bge $a0, $t1, else2
				
				#insira na esquerda 
				#insere(no, raiz->filhoEsq);
				add $a1, $t0, 4 # $a1 = &(raiz->filhoEsq)
				jal insere
				
				j then
			else2: #senao, insira na direita
				add $a1, $t0, 8 # $a1 = &(raiz->filhoDir)
				jal insere
			
		then:
		
		#recupera endereco de retorno
		lw $ra, ($sp)
		add $sp, $sp, 4
		
		jr $ra
		