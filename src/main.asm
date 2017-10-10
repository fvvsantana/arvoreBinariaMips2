.data
	opcoes:	.asciiz "\nDigite o numero correspondente a operacao desejada:\n 1- Insercao\n 2- Percorrimento pre-ordem\n 3- Percorrimento em-ordem\n 4- Percorrimento pos-ordem\n 5- Sair\n"
	erro:	.asciiz "\nValor invalido, tente novamente."
	valor:	.asciiz "Digite o valor:\n"
	
.text
	.globl main
	main:
		# aloca espaco para o ponteiro que aponta para o no raiz da arvore 
		sub $sp, $sp, 4
		
		# $s0 aponta para a raiz
		move $s0, $sp
		
		# inicia a arvore
		move $a0, $s0
		jal criaArvore
		
	# funcao que imprime continuamente o menu
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
		
		# verifica cada valor possivel e chama a funcao adequada
		# digitar:
		beq $s1, 1, digitaValor
		
		# pre ordem:
		beq $s1, 2, preOrdem 
		
		# em ordem:
		beq $s1, 3, emOrdem
		
		# pos ordem:
		beq $s1, 4, posOrdem
		
		# sair:
		beq $s1, 5, sair
		
		# se nenhum caso deu certo, foi valor invalido
		li $v0, 4
		la $a0, erro
		syscall
		
		# volta para o comeco
		j menu
		
	# solicita um valor e insere na arvore
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
		# exit
		li $v0, 10
		syscall
		
