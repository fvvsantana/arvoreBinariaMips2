.data
	opcoes:	.asciiz "\n\nDigite o numero correspondente a operacao desejada:\n 1- Insercao\n 2- Percorrimento pre-ordem\n 3- Percorrimento em-ordem\n 4- Percorrimento pos-ordem\n 5- Sair\n"
	erro:	.asciiz "\nValor invalido, tente novamente."
	valor:	.asciiz "Digite o valor:\n"
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
		
		j menu
		
		#testa alocacao
		#move $a0, $s0
		#jal testInsere
		
		#volta $sp para o topo da stack
		move $sp, $fp
		
	menu:
		# imprime as opcoes
		li $v0, 4
		la $a0, opcoes
		syscall
		
		# le o numero digitado
		li $v0, 5
		syscall
		
		# salva o valor em $s1
		move $s1, $v0
	
		# define o arguemento padrao para a maioria das funcoes
		lw $a0, ($sp)
		
		# verifica cada valor possivel
		# digitar:
		beq $s1, 1, digitaValor
		
		# em ordem:
		beq $s1, 3, emOrdem 
		
		# sair:
		beq $s1, 5, sair
		
		# se nenhum caso deu certo, foi valor invalido
		li $v0, 4
		la $a0, erro
		syscall
		
		# volta para o comeco
		j menu
		
	digitaValor:
		# imprime string
		li $v0, 4
		la $a0, valor
		syscall
		
		# obtem o valor
		li $v0, 5
		syscall
		
		# define os argumentos para insercao
		move $a0, $v0
		move $a1, $s0
		
		# chama a funcao de insercao
		jal insere
		
		# volta para o menu
		j menu
		
	sair:
		#exit
		li $v0, 10
		syscall
		