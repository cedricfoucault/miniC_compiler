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
	movl	$4, %eax
	movl	%eax, -8(%ebp)
	pushl	%eax
	movl	$3, %eax
	movl	%eax, -8(%ebp)
	popl	%ebx
	addl	%ebx, %eax
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	$.main_1, %eax
	pushl	%eax
	call	printf
	addl	$12, %esp
	movl	stdout, %eax
	pushl	%eax
	call	fflush
	addl	$4, %esp
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$8, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.main_1:
	.string	"Valeur de j=%d (normalement 7), valeur de i=%d.\n"
	.align	4
