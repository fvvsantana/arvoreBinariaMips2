.data
	virgula: .asciiz ","
	ponto: .asciiz "."
	titulopreordem: .asciiz "preOrdem:"

.text
	.globl preOrdem
	
	preOrdem:
		move $t0, $a0
		li $v0, 4
		la $a0, titulopreordem
		syscall
		
		move $a0, $t0
	rec:
		
		#if (!$a0) vai para fim
		beq $a0, -1, fim
		
		#else{
		#aloca espa�o na stack
		sub $sp, $sp, 4
		#guarda o endere�o de retorno
		sw $ra, ($sp)
		
		#aloca espa�o na stack
		sub $sp, $sp, 4
		#guarda o n� na pilha
		sw  $a0, ($sp)
		
		#printa a cabe�a do n�
		li $v0, 1
		syscall
		
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
		move $a0, 4($a0)
		#chama a fun��o
		jal rec
		
		
		
		#$a0 = $a0->direita
		move $a0, 8($a0)
		#chama a fun��o
		jal rec
	
	
	fim:
		jr $ra
		
	
