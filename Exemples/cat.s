.globl __exception_handler
	.bss
	.align 4
	.type __exception_handler, @object
	.size __exception_handler, 4
__exception_handler:
	.zero 4

	.text
.globl main
	.type	main,@function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$1, %eax
	movl	%eax, -8(%ebp)
	jmp	.main_1
.main_2:
	subl	$4, %esp
	movl	$.main_3, %eax
	pushl	%eax
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	movl	(%eax, %ebx, 4), %eax
	pushl	%eax
	call	fopen
	addl	$8, %esp
	movl	%eax, -12(%ebp)
	jmp	.main_4
.main_5:
	movl	stdout, %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	pushl	%eax
	call	fputc
	addl	$8, %esp
.main_4:
	movl	$1, %eax
	negl	%eax
	pushl	%eax
	movl	-12(%ebp), %eax
	pushl	%eax
	call	fgetc
	addl	$4, %esp
	movl	%eax, -4(%ebp)
	popl	%ebx
	cmpl	%ebx, %eax
	je	.main_8
	movl	$0, %eax
	jmp	.main_9
.main_8:
	movl	$1, %eax
.main_9:
	cmpl	$0, %eax
	je	.main_6
	movl	$0, %eax
	jmp	.main_7
.main_6:
	movl	$1, %eax
.main_7:
	cmpl	$0, %eax
	jnz	.main_5
	movl	-12(%ebp), %eax
	pushl	%eax
	call	fclose
	addl	$4, %esp
	addl	$4, %esp
	movl	-8(%ebp), %eax
	addl	$1, -8(%ebp)
.main_1:
	movl	8(%ebp), %eax
	pushl	%eax
	movl	-8(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.main_10
	movl	$0, %eax
	jmp	.main_11
.main_10:
	movl	$1, %eax
.main_11:
	cmpl	$0, %eax
	jnz	.main_2
	movl	stdout, %eax
	pushl	%eax
	call	fflush
	addl	$4, %esp
	movl	$0, %eax
	pushl	%eax
	call	exit
	addl	$4, %esp
	addl	$8, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.main_3:
	.string	"r"
	.align	4
