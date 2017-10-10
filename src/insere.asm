.data
	newline: .asciiz "\n"
	virgula: .asciiz ","
	
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
		
		lw $a0, ($a1)
		
		preOrdem:
		
		
		#if (!$a0) vai para fim
		beq $a0, -1, fim
		
		#else{
		#aloca espaço na stack
		sub $sp, $sp, 4
		#guarda o endereço de retorno
		sw $ra, ($sp)
		
		#aloca espaço na stack
		sub $sp, $sp, 4
		#guarda o nó na pilha
		sw  $a0, ($sp)
		
		#printa a cabeça do nó :
		
		#salva a0 em t0
		move $t0, $a0
		#$a0 = nó cabeça
		lw $a0, ($a0)
		#printa
		li $v0, 1
		syscall
		
		#$t0 retorna a $a0
		move $a0, $t0
		
		#printa a virgula:
		li $v0, 4
		#guarda a0 em t0
		move $t0, $a0
		#poem a virgula em a0
		la $a0, virgula
		#printa
		syscall
		#retorna $t0 em $a0
		move $a0, $t0
		
		
		
		#$a0 = $a0->esquerda
		lw $a0, 4($a0)
		#chama a função
		jal preOrdem
		
		#recupera endereço
		lw $a0, ($sp)
		#desaloca stack
		add $sp, $sp, 4
		
		
		#$a0 = $a0->direita
		lw $a0, 8($a0)
		#chama a função
		jal preOrdem
		
		#recupera o ra
		lw $ra , ($sp)
		#desaloca stack
		add $sp, $sp, 4
	
	fim:
		jr $ra
		
		#retorma endereco de retorno
		lw $ra, -4($fp)
		add $sp, $fp, 4
		lw $fp, 0($fp) 
		
		jr $ra
		
		
		
		
		
