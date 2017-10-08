.data

.text
	.globl main
	main:
		#salva o topo da stack
		move $fp, $sp
		
		#typedef struct{
		#	No* raiz;
		#}Arvore;
		#aloca espaco para o ponteiro que aponta para o no raiz da arvore 
		#(No* raiz)
		sub $sp, $sp, 4
		
		#$s0 aponta para a raiz
		move $s0, $sp
		
		#faz a raiz apontar pra nulo
		move $a0, $s0
		jal criaArvore
		
		#testa alocacao
		move $a0, $s0
		jal testInsere
		
		#Carrega em a0 o endereço da raiz da arvore
		lw $a0, 0($s0)
		#Executa o percorrimento pos-Ordem
		jal posOrdem
		
		#volta $sp para o topo da stack
		move $sp, $fp
		#exit
		li $v0, 10
		syscall
		
