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
	movl	$2, %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.main_5
	movl	$0, %eax
	jmp	.main_6
.main_5:
	movl	$1, %eax
.main_6:
	cmpl	$0, %eax
	je	.main_3
	movl	$0, %eax
	jmp	.main_4
.main_3:
	movl	$1, %eax
.main_4:
	cmpl	$0, %eax
	je	.main_1
	movl	$.main_7, %eax
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
	jmp	.main_2
.main_1:
.main_2:
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
	movl	$2, %eax
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
	je	.main_8
	movl	$.main_12, %eax
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
	jmp	.main_9
.main_8:
.main_9:
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	$4, %eax
	popl	%ebx
	imull	%ebx, %eax
	pushl	%eax
	call	malloc
	addl	$4, %esp
	movl	%eax, -4(%ebp)
	movl	$0, %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.main_15
	movl	$0, %eax
	jmp	.main_16
.main_15:
	movl	$1, %eax
.main_16:
	cmpl	$0, %eax
	je	.main_13
	movl	$.main_17, %eax
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
	jmp	.main_14
.main_13:
.main_14:
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	pushl	%eax
	call	zero_sieve
	addl	$8, %esp
	movl	$0, %eax
	pushl	%eax
	movl	$1, %eax
	pushl	%eax
	movl	$1, %eax
	popl	%ebx
	movl	-4(%ebp), %ecx
	movl	%eax, (%ecx,%ebx,4)
	popl	%ebx
	movl	-4(%ebp), %ecx
	movl	%eax, (%ecx,%ebx,4)
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	pushl	%eax
	call	fill_sieve
	addl	$8, %esp
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	pushl	%eax
	call	print_sieve
	addl	$8, %esp
	movl	-4(%ebp), %eax
	pushl	%eax
	call	free
	addl	$4, %esp
	addl	$8, %esp
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	movl	%ebp, %esp
	popl	%ebp
	ret
.globl zero_sieve
	.type	zero_sieve,@function
zero_sieve:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	$0, %eax
	movl	%eax, -4(%ebp)
	jmp	.zero_sieve_18
.zero_sieve_19:
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	$0, %eax
	popl	%ebx
	movl	8(%ebp), %ecx
	movl	%eax, (%ecx,%ebx,4)
	movl	-4(%ebp), %eax
	addl	$1, -4(%ebp)
.zero_sieve_18:
	movl	12(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.zero_sieve_20
	movl	$0, %eax
	jmp	.zero_sieve_21
.zero_sieve_20:
	movl	$1, %eax
.zero_sieve_21:
	cmpl	$0, %eax
	jnz	.zero_sieve_19
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$4, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.globl fill_sieve
	.type	fill_sieve,@function
fill_sieve:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	$2, %eax
	movl	%eax, -4(%ebp)
	jmp	.fill_sieve_22
.fill_sieve_23:
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	12(%ebp), %eax
	pushl	%eax
	movl	8(%ebp), %eax
	pushl	%eax
	call	cross_out_prime
	addl	$12, %esp
	jmp	.fill_sieve_24
.fill_sieve_25:
.fill_sieve_24:
	movl	12(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -4(%ebp)
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.fill_sieve_28
	movl	$0, %eax
	jmp	.fill_sieve_29
.fill_sieve_28:
	movl	$1, %eax
.fill_sieve_29:
	cmpl	$0, %eax
	je	.fill_sieve_26
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	movl	(%eax, %ebx, 4), %eax
	jmp	.fill_sieve_27
.fill_sieve_26:
	movl	$0, %eax
.fill_sieve_27:
	cmpl	$0, %eax
	jnz	.fill_sieve_25
.fill_sieve_22:
	movl	12(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.fill_sieve_30
	movl	$0, %eax
	jmp	.fill_sieve_31
.fill_sieve_30:
	movl	$1, %eax
.fill_sieve_31:
	cmpl	$0, %eax
	jnz	.fill_sieve_23
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$4, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.globl cross_out_prime
	.type	cross_out_prime,@function
cross_out_prime:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	16(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.cross_out_prime_32
.cross_out_prime_33:
	movl	16(%ebp), %eax
	pushl	%eax
	movl	$1, %eax
	popl	%ebx
	movl	8(%ebp), %ecx
	movl	%eax, (%ecx,%ebx,4)
.cross_out_prime_32:
	movl	12(%ebp), %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	16(%ebp), %eax
	popl	%ebx
	addl	%ebx, %eax
	movl	%eax, 16(%ebp)
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.cross_out_prime_34
	movl	$0, %eax
	jmp	.cross_out_prime_35
.cross_out_prime_34:
	movl	$1, %eax
.cross_out_prime_35:
	cmpl	$0, %eax
	jnz	.cross_out_prime_33
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$4, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.globl print_sieve
	.type	print_sieve,@function
print_sieve:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	12(%ebp), %eax
	pushl	%eax
	movl	$.print_sieve_36, %eax
	pushl	%eax
	call	printf
	addl	$8, %esp
	movl	$.print_sieve_37, %eax
	movl	%eax, -16(%ebp)
	movl	$0, %eax
	movl	%eax, -8(%ebp)
	movl	$0, %eax
	movl	%eax, -12(%ebp)
	jmp	.print_sieve_38
.print_sieve_39:
	movl	$0, %eax
	pushl	%eax
	movl	-12(%ebp), %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	movl	(%eax, %ebx, 4), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.print_sieve_42
	movl	$0, %eax
	jmp	.print_sieve_43
.print_sieve_42:
	movl	$1, %eax
.print_sieve_43:
	cmpl	$0, %eax
	je	.print_sieve_40
	movl	-12(%ebp), %eax
	pushl	%eax
	movl	-16(%ebp), %eax
	pushl	%eax
	movl	$.print_sieve_44, %eax
	pushl	%eax
	call	printf
	addl	$12, %esp
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -8(%ebp)
	pushl	%eax
	movl	$4, %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jle	.print_sieve_47
	movl	$0, %eax
	jmp	.print_sieve_48
.print_sieve_47:
	movl	$1, %eax
.print_sieve_48:
	cmpl	$0, %eax
	je	.print_sieve_45
	movl	$.print_sieve_49, %eax
	pushl	%eax
	call	printf
	addl	$4, %esp
	movl	$0, %eax
	movl	%eax, -8(%ebp)
	movl	$.print_sieve_37, %eax
	movl	%eax, -16(%ebp)
	jmp	.print_sieve_46
.print_sieve_45:
	movl	$.print_sieve_50, %eax
	pushl	%eax
	call	printf
	addl	$4, %esp
.print_sieve_46:
	jmp	.print_sieve_41
.print_sieve_40:
.print_sieve_41:
	movl	-12(%ebp), %eax
	addl	$1, -12(%ebp)
.print_sieve_38:
	movl	12(%ebp), %eax
	pushl	%eax
	movl	-12(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.print_sieve_51
	movl	$0, %eax
	jmp	.print_sieve_52
.print_sieve_51:
	movl	$1, %eax
.print_sieve_52:
	cmpl	$0, %eax
	jnz	.print_sieve_39
	movl	stdout, %eax
	pushl	%eax
	call	fflush
	addl	$4, %esp
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.print_sieve_50:
	.string	" "
	.align	4
.print_sieve_49:
	.string	"\n"
	.align	4
.print_sieve_44:
	.string	"%s%8d"
	.align	4
.print_sieve_37:
	.string	"  "
	.align	4
.print_sieve_36:
	.string	"Les nombres premiers inferieurs a %d sont:\n"
	.align	4
.main_17:
	.string	"%d est trop gros, je n'ai pas assez de place memoire...\n"
	.align	4
.main_12:
	.string	"Ah non, quand meme, un nombre >=2, s'il-vous-plait...\n"
	.align	4
.main_7:
	.string	"Usage: ./sieve <n>\ncalcule et affiche les nombres premiers inferieurs a <n>.\n"
	.align	4
