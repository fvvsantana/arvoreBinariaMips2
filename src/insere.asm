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
		
	.globl testInsere
	testInsere:#(No** arvore)
		
		sub $sp, $sp, 4
		sw $fp, 0($sp)
		move $fp, $sp
		#salva o endereco de retorno 
		sub $sp, $sp, 8
		sw $ra, -4($fp)
		sw $a0, -8($fp)
		
		#insere elementos
		li $a0, 5
		lw $a1, -8($fp)
		jal insere
			
		li $a0, 3
		lw $a1, -8($fp)
		jal insere
		
		li $a0, 7
		lw $a1, -8($fp)
		jal insere
		
		li $a0, 2
		lw $a1, -8($fp)
		jal insere
		
		li $a0, 4
		lw $a1, -8($fp)
		jal insere
		
		li $a0, 6
		lw $a1, -8($fp)
		jal insere
		
		li $a0, 8
		lw $a1, -8($fp)
		jal insere
		
		#imprime arvore:
		
		#raiz
		lw $a1, -8($fp) #a1 = &(raiz)	
		lw $t0, ($a1) #$t0 = raiz
		lw $t1, ($t0) #$t1 = raiz->elem
		
		#imprime elem
		move $a0, $t1
		li $v0, 1
		syscall
		
		#imprime newline
		li $v0, 4
		la $a0, newline
		syscall
		
		#filhoEsq
		add $t1, $t0, 4 #$t1 = &(raiz->filhoEsq)
		lw $t1, ($t1) #$t1 = raiz->filhoEsq
		lw $t1, ($t1) #$t1 = raiz->filhoEsq->elem
		
		#imprime elem
		move $a0, $t1
		li $v0, 1
		syscall
		
		#imprime newline
		li $v0, 4
		la $a0, newline
		syscall
		
		#filhoDir
		add $t1, $t0, 8 #$t1 = &(raiz->filhoDir)
		lw $t1, ($t1) #$t1 = raiz->filhoDir
		lw $t1, ($t1) #$t1 = raiz->filhoDir->elem
		
		#imprime elem
		move $a0, $t1
		li $v0, 1
		syscall
		
		#imprime newline
		li $v0, 4
		la $a0, newline
		syscall
		
		
		#retorma endereco de retorno
		lw $ra, -4($fp)
		add $sp, $fp, 4
		lw $fp, 0($fp) 
		
		jr $ra
		
		
		
		
		
