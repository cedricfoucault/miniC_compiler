.globl __exception_handler
	.bss
	.align 4
	.type __exception_handler, @object
	.size __exception_handler, 4
__exception_handler:
	.zero 4

	.text
.globl fact
	.type	fact,@function
fact:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	$1, %eax
	movl	%eax, -4(%ebp)
	jmp	.fact_1
.fact_2:
	movl	8(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	popl	%ebx
	imull	%ebx, %eax
	movl	%eax, -4(%ebp)
	movl	8(%ebp), %eax
	subl	$1, 8(%ebp)
.fact_1:
	movl	$0, %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.fact_5
	movl	$0, %eax
	jmp	.fact_6
.fact_5:
	movl	$1, %eax
.fact_6:
	cmpl	$0, %eax
	je	.fact_3
	movl	$0, %eax
	jmp	.fact_4
.fact_3:
	movl	$1, %eax
.fact_4:
	cmpl	$0, %eax
	jnz	.fact_2
	movl	-4(%ebp), %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$4, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.globl main
	.type	main,@function
main:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$2, %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.main_11
	movl	$0, %eax
	jmp	.main_12
.main_11:
	movl	$1, %eax
.main_12:
	cmpl	$0, %eax
	je	.main_9
	movl	$0, %eax
	jmp	.main_10
.main_9:
	movl	$1, %eax
.main_10:
	cmpl	$0, %eax
	je	.main_7
	movl	$.main_13, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$8, %esp
	movl	stderr, %eax
	pushl	%eax
	call	fflush
	addl	$4, %esp
	movl	$10, %eax
	pushl	%eax
	call	exit
	addl	$4, %esp
	jmp	.main_8
.main_7:
.main_8:
	subl	$8, %esp
	movl	$1, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	movl	(%eax, %ebx, 4), %eax
	pushl	%eax
	call	atoi
	addl	$4, %esp
	movl	%eax, -8(%ebp)
	movl	$0, %eax
	pushl	%eax
	movl	-8(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.main_16
	movl	$0, %eax
	jmp	.main_17
.main_16:
	movl	$1, %eax
.main_17:
	cmpl	$0, %eax
	je	.main_14
	movl	$.main_18, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$8, %esp
	movl	stderr, %eax
	pushl	%eax
	call	fflush
	addl	$4, %esp
	movl	$10, %eax
	pushl	%eax
	call	exit
	addl	$4, %esp
	jmp	.main_15
.main_14:
.main_15:
	movl	-8(%ebp), %eax
	pushl	%eax
	call	fact
	addl	$4, %esp
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	$.main_19, %eax
	pushl	%eax
	call	printf
	addl	$12, %esp
	addl	$8, %esp
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	movl	%ebp, %esp
	popl	%ebp
	ret
.main_19:
	.string	"La factorielle de %d vaut %d (en tout cas, modulo 2^32...).\n"
	.align	4
.main_18:
	.string	"Ah non, quand meme, un nombre positif ou nul, s'il-vous-plait...\n"
	.align	4
.main_13:
	.string	"Usage: ./fact <n>\ncalcule et affiche la factorielle de <n>.\n"
	.align	4
