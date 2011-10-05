.globl __exception_handler
	.bss
	.align 4
	.type __exception_handler, @object
	.size __exception_handler, 4
__exception_handler:
	.zero 4

	.text
.globl f
	.type	f,@function
f:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$0, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.f_3
	movl	$0, %eax
	jmp	.f_4
.f_3:
	movl	$1, %eax
.f_4:
	cmpl	$0, %eax
	je	.f_1
	movl	8(%ebp), %eax
	movl	%eax, %ecx
	movl	$.f_5, %ebx
	// On lance l'exception %ebx, avec valeur %ecx.
	// Depilons __exception_handler.
	movl	__exception_handler, %eax
	// On doit d'abord verifier que __exception_handler!=NULL.
	cmpl	$0, %eax
	jne	.f_6
	// Si __exception_handler==NULL, on est arrive au bout de la pile d'exceptions,
	// et l'on choisit d'afficher un message informatif et de s'arreter en urgence,
	// plutot que de laisser le programme se planter salement tout seul.
	pushl	%ebx
	pushl	$.f_7
	pushl	stderr
	call	fprintf
	call	fflush
	jmp	abort
.f_6:
	// Sinon, on recupere la suite de la pile d'exceptions dans %esi,
	// et on la met dans __exception_handler.
	// Il serait plus elegant d'appeler free() sur %esi, aussi (laisse en exercice).
	movl	(%eax), %esi
	movl	%esi, __exception_handler
	// On recupere l'adresse ou il faudra continuer l'execution dans %esi,
	movl	4(%eax), %esi
	// puis le %ebp sauvegarde,
	movl	12(%eax), %ebp
	// puis le %esp sauvegarde (ce qui revient a depiler %esp assez brutalement).
	movl	8(%eax), %esp
	// Et hop, on saute vers le code qui va traiter l'exception.
	jmp	*%esi
	jmp	.f_2
.f_1:
.f_2:
	movl	$1, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.f_10
	movl	$0, %eax
	jmp	.f_11
.f_10:
	movl	$1, %eax
.f_11:
	cmpl	$0, %eax
	je	.f_8
	movl	8(%ebp), %eax
	movl	%eax, %ecx
	movl	$.f_12, %ebx
	// On lance l'exception %ebx, avec valeur %ecx.
	// Depilons __exception_handler.
	movl	__exception_handler, %eax
	// On doit d'abord verifier que __exception_handler!=NULL.
	cmpl	$0, %eax
	jne	.f_13
	// Si __exception_handler==NULL, on est arrive au bout de la pile d'exceptions,
	// et l'on choisit d'afficher un message informatif et de s'arreter en urgence,
	// plutot que de laisser le programme se planter salement tout seul.
	pushl	%ebx
	pushl	$.f_7
	pushl	stderr
	call	fprintf
	call	fflush
	jmp	abort
.f_13:
	// Sinon, on recupere la suite de la pile d'exceptions dans %esi,
	// et on la met dans __exception_handler.
	// Il serait plus elegant d'appeler free() sur %esi, aussi (laisse en exercice).
	movl	(%eax), %esi
	movl	%esi, __exception_handler
	// On recupere l'adresse ou il faudra continuer l'execution dans %esi,
	movl	4(%eax), %esi
	// puis le %ebp sauvegarde,
	movl	12(%eax), %ebp
	// puis le %esp sauvegarde (ce qui revient a depiler %esp assez brutalement).
	movl	8(%eax), %esp
	// Et hop, on saute vers le code qui va traiter l'exception.
	jmp	*%esi
	jmp	.f_9
.f_8:
.f_9:
	movl	$2, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	$0, %eax
	je	.f_14
	movl	$1, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	pushl	%eax
	movl	$3, %eax
	popl	%ebx
	imull	%ebx, %eax
	popl	%ebx
	addl	%ebx, %eax
	pushl	%eax
	movl	$1, %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	addl	%ebx, %eax
	pushl	%eax
	call	f
	addl	$8, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	jmp	.f_15
.f_14:
	movl	$2, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	cltd
	idivl	%ebx
	pushl	%eax
	movl	$1, %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	addl	%ebx, %eax
	pushl	%eax
	call	f
	addl	$8, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.f_15:
	movl	%ebp, %esp
	popl	%ebp
	ret
.globl main
	.type	main,@function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	$2, %eax
	pushl	%eax
	movl	8(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	je	.main_20
	movl	$0, %eax
	jmp	.main_21
.main_20:
	movl	$1, %eax
.main_21:
	cmpl	$0, %eax
	je	.main_18
	movl	$0, %eax
	jmp	.main_19
.main_18:
	movl	$1, %eax
.main_19:
	cmpl	$0, %eax
	je	.main_16
	movl	$.main_22, %eax
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
	jmp	.main_17
.main_16:
.main_17:
	movl	$1, %eax
	pushl	%eax
	movl	12(%ebp), %eax
	popl	%ebx
	movl	(%eax, %ebx, 4), %eax
	pushl	%eax
	call	atoi
	addl	$4, %esp
	movl	%eax, -4(%ebp)
	// Debut d'une instruction try { ... }.
	// On va empiler dans la liste __exception_handler suffisamment d'infos
	// pour pouvoir retrouver nos billes lorsqu'une exception sera lancee par throw.
	// Pour ceci, on alloue une structure que l'on pourrait ecrire en C:
	//   struct xhandler { struct xhandler *next; char *next_eip, *save_esp, *save_ebp; }
	// Le champ next sert a retrouver la suite de la liste,
	// le champ next_eip sera l'adresse du code qui traitera les catch { ... }
	// et les finally du try { ... } courant,
	// le champ save_esp est une sauvegarde du pointeur de pile courant,
	// et save_ebp sauvegarde %ebp.
	// Cette structure fait 16 octets: on commence par l'allouer.
	push	$16
	call	malloc
	addl	$4, %esp
	// %eax->next = __exception_handler;
	movl	__exception_handler, %ebx
	movl	%ebx, (%eax)
	// exception_handler = %eax;
	movl	%eax, __exception_handler
	// %eax->next_eip = &.main_23;  // c'est la qu'on ira si une exception est lancee!
	movl	$.main_23, %ebx
	movl	%ebx, 4(%eax)
	// %eax->save_esp = %esp;
	movl	%esp, 8(%eax)
	// %eax->save_ebp = %ebp;
	movl	%ebp, 12(%eax)
	// Maintenant que le handler a ete empile, on passe au corps du try { ... }.
	movl	$0, %eax
	pushl	%eax
	movl	-4(%ebp), %eax
	popl	%ebx
	cmpl	%ebx, %eax
	jl	.main_29
	movl	$0, %eax
	jmp	.main_30
.main_29:
	movl	$1, %eax
.main_30:
	cmpl	$0, %eax
	je	.main_27
	movl	$.main_31, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$8, %esp
	jmp	.main_28
.main_27:
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	$0, %eax
	pushl	%eax
	call	f
	addl	$8, %esp
.main_28:
	// Fin du corps du try { ... }.  On doit depiler le handler d'exception,
	// et traiter le finally { ... } s'il y en a un.  Ceci sera fait en .main_24.
	jmp	.main_24
	// Au cas ou le corps du try terminerait en faisant un return, on doit executer
	// le bloc finally.  C'est ici qu'on le fera.
.main_26:
	// On remet d'abord la pile au niveau auquel le compilateur pense qu'elle est:
	leal	-4(%ebp), %esp
	// On sauvegarde ensuite le resultat a retourner via return:
	pushl	%eax
	// Puis on calcule le corps du finally:
	movl	$.main_32, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$8, %esp
	// On depile la valeur a retourner:
	popl	%eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	// Ici, on va traiter des catch (...) successifs.
	// Le nom de l'exception sera dans le registre %ebx,
	// la valeur de l'exception sera dans %ecx,
	// et le handler empile par le try { ... } a deja ete depile par le throw responsable du lancement de l'exception.
.main_23:
	// On commence par empiler la valeur %ecx de l'exception.
	pushl	%ecx
	// Entree de catch(Trouve ...): on compare le nom de l'exception a 'Trouve'.
	pushl	%ebx
	pushl	$.f_12
	call	strcmp
	addl	$8, %esp
	// Note: %ebx n'est pas modifie par strcmp(), on dispose donc toujours du nom de l'exception.
	cmpl	$0, %eax
	jnz	.main_33
	// Corps du catch (Trouve ...).
	movl	-4(%ebp), %eax
	pushl	%eax
	movl	-8(%ebp), %eax
	pushl	%eax
	movl	$.main_34, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$16, %esp
	// On depile la valeur de l'exception, et on va traiter le finally { ... } s'il y en a un.
	addl	$4, %esp
	jmp	.main_25
.main_33:
	// Clause finally { ... }, exception non rattrapee.  On execute le corps
	// du finally { ... } et on relance l'exception.
	pushl	%ebx
	movl	$.main_32, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$8, %esp
	popl	%ebx
	popl	%ecx
	// On lance l'exception %ebx, avec valeur %ecx.
	// Depilons __exception_handler.
	movl	__exception_handler, %eax
	// On doit d'abord verifier que __exception_handler!=NULL.
	cmpl	$0, %eax
	jne	.main_35
	// Si __exception_handler==NULL, on est arrive au bout de la pile d'exceptions,
	// et l'on choisit d'afficher un message informatif et de s'arreter en urgence,
	// plutot que de laisser le programme se planter salement tout seul.
	pushl	%ebx
	pushl	$.f_7
	pushl	stderr
	call	fprintf
	call	fflush
	jmp	abort
.main_35:
	// Sinon, on recupere la suite de la pile d'exceptions dans %esi,
	// et on la met dans __exception_handler.
	// Il serait plus elegant d'appeler free() sur %esi, aussi (laisse en exercice).
	movl	(%eax), %esi
	movl	%esi, __exception_handler
	// On recupere l'adresse ou il faudra continuer l'execution dans %esi,
	movl	4(%eax), %esi
	// puis le %ebp sauvegarde,
	movl	12(%eax), %ebp
	// puis le %esp sauvegarde (ce qui revient a depiler %esp assez brutalement).
	movl	8(%eax), %esp
	// Et hop, on saute vers le code qui va traiter l'exception.
	jmp	*%esi
.main_24:
	// Aucune exception n'a ete lancee, il faut d'abord
	// depiler __exception_handler avant de continuer.
	// Depilons __exception_handler.
	movl	__exception_handler, %eax
	// On doit d'abord verifier que __exception_handler!=NULL.
	cmpl	$0, %eax
	jne	.main_36
	// Si __exception_handler==NULL, on est arrive au bout de la pile d'exceptions,
	// et l'on choisit d'afficher un message informatif et de s'arreter en urgence,
	// plutot que de laisser le programme se planter salement tout seul.
	pushl	%ebx
	pushl	$.f_7
	pushl	stderr
	call	fprintf
	call	fflush
	jmp	abort
.main_36:
	// Sinon, on recupere la suite de la pile d'exceptions dans %esi,
	// et on la met dans __exception_handler.
	// Il serait plus elegant d'appeler free() sur %esi, aussi (laisse en exercice).
	movl	(%eax), %esi
	movl	%esi, __exception_handler
	// Ici, l'exception a ete rattrapee par un catch, et __exception_handler
	// a ete depile par le throw.  On fait le finally et on continue.
.main_25:
	movl	$.main_32, %eax
	pushl	%eax
	movl	stderr, %eax
	pushl	%eax
	call	fprintf
	addl	$8, %esp
	movl	stderr, %eax
	pushl	%eax
	call	fflush
	addl	$4, %esp
	movl	$0, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
	addl	$4, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
.main_34:
	.string	"La suite termine apres %d iterations en partant de %d.\n"
	.align	4
.main_32:
	.string	"*Fin* (ce message doit toujours s'afficher).\n"
	.align	4
.main_31:
	.string	"Pas trouve...\n"
	.align	4
.main_22:
	.string	"Usage: ./exc1 <n>\ncalcule a quelle iteration une suite mysterieuse termine, en partant de <n>.\n"
	.align	4
.f_12:
	.string	"Trouve"
	.align	4
.f_7:
	.string	"Uncaught exception %s: abort.\n"
	.align	4
.f_5:
	.string	"Zero"
	.align	4
