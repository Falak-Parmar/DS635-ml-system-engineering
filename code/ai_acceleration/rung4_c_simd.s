	.file	"rung4_c_simd.c"
	.text
	.p2align 4
	.type	matmul_wrap, @function
matmul_wrap:
.LFB58:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -64(%rsp)
	testl	%ecx, %ecx
	jle	.L37
	movslq	%ecx, %rbx
	movl	%ecx, %eax
	xorl	%r12d, %r12d
	movq	%rdi, -8(%rsp)
	movq	%rbx, -24(%rsp)
	salq	$2, %rbx
	leal	-3(%rax), %r8d
	movl	%eax, %r13d
	movq	%rbx, -72(%rsp)
	leal	(%rcx,%rcx), %ebx
	andl	$-2, %r8d
	movq	%rdx, %r14
	movl	%ebx, -84(%rsp)
	movslq	%ebx, %rbx
	leal	3(%r8), %r9d
	andl	$-8, %r13d
	movq	%rbx, -96(%rsp)
	leal	-1(%rcx), %ebx
	shrl	$3, %ecx
	movl	%r12d, %r8d
	movl	%ebx, -12(%rsp)
	movq	%rcx, %rbx
	xorl	%ecx, %ecx
	xorl	%r15d, %r15d
	salq	$5, %rbx
	xorl	%edi, %edi
	movl	%ecx, -16(%rsp)
	movl	%r9d, -56(%rsp)
	movq	%rbx, %r12
.L3:
	xorl	%ebx, %ebx
	cmpl	$2, %eax
	jle	.L19
	movl	-16(%rsp), %ecx
	movl	-56(%rsp), %r11d
	movl	$0, -32(%rsp)
	movq	%rdx, -40(%rsp)
	movl	%edi, -76(%rsp)
	movq	%r15, -48(%rsp)
	movl	%r8d, -80(%rsp)
	leal	1(%rcx), %ebx
	addl	%r11d, %ecx
	movl	%eax, %r11d
	movl	%ebx, -28(%rsp)
	movq	-8(%rsp), %rbx
	movl	%ecx, -52(%rsp)
	xorl	%ecx, %ecx
	addq	$4, %rbx
	cmpl	$6, -12(%rsp)
	vmovss	-4(%rbx), %xmm3
	jbe	.L22
.L41:
	vbroadcastss	(%rbx), %ymm1
	movq	-40(%rsp), %rdx
	movslq	%r11d, %rdi
	leaq	(%rsi,%rcx,4), %r9
	leaq	(%rsi,%rdi,4), %r8
	vbroadcastss	%xmm3, %ymm2
	xorl	%edi, %edi
	.p2align 4
	.p2align 3
.L16:
	vmovups	(%r9,%rdi), %ymm0
	vfmadd213ps	(%rdx,%rdi), %ymm2, %ymm0
	vfmadd231ps	(%r8,%rdi), %ymm1, %ymm0
	vmovups	%ymm0, (%rdx,%rdi)
	addq	$32, %rdi
	cmpq	%r12, %rdi
	jne	.L16
	movq	%rdx, -40(%rsp)
	cmpl	%eax, %r13d
	je	.L4
	movl	%r13d, %edi
	movl	%r13d, %r8d
.L15:
	movl	%eax, %r10d
	subl	%edi, %r10d
	leal	-1(%r10), %r9d
	cmpl	$2, %r9d
	jbe	.L5
	movq	-48(%rsp), %r15
	movq	-64(%rsp), %rdx
	vshufps	$0, %xmm3, %xmm3, %xmm1
	leaq	(%r15,%rdi), %r9
	leaq	(%r14,%r9,4), %r15
	movslq	%r11d, %r9
	addq	%rdi, %r9
	vmovups	(%r15), %xmm5
	addq	%rcx, %rdi
	vfmadd132ps	(%rsi,%rdi,4), %xmm5, %xmm1
	movslq	-28(%rsp), %rdi
	vbroadcastss	(%rdx,%rdi,4), %xmm0
	movl	%r10d, %edi
	vfmadd132ps	(%rsi,%r9,4), %xmm1, %xmm0
	andl	$-4, %edi
	addl	%edi, %r8d
	andl	$3, %r10d
	vmovups	%xmm0, (%r15)
	je	.L4
.L5:
	movl	-16(%rsp), %edx
	movl	-32(%rsp), %r15d
	vmovss	(%rbx), %xmm0
	leal	(%rdx,%r8), %edi
	movslq	%edi, %rdi
	leaq	(%r14,%rdi,4), %r9
	leal	(%r15,%r8), %edi
	movslq	%edi, %rdi
	vmovss	(%rsi,%rdi,4), %xmm1
	leal	(%r11,%r8), %edi
	vfmadd213ss	(%r9), %xmm3, %xmm1
	movslq	%edi, %rdi
	vfmadd231ss	(%rsi,%rdi,4), %xmm0, %xmm1
	leal	1(%r8), %edi
	vmovss	%xmm1, (%r9)
	cmpl	%edi, %eax
	jle	.L4
	leal	(%rdx,%rdi), %r9d
	addl	$2, %r8d
	movslq	%r9d, %r9
	leaq	(%r14,%r9,4), %r10
	leal	(%r15,%rdi), %r9d
	addl	%r11d, %edi
	movslq	%r9d, %r9
	movslq	%edi, %rdi
	vmovss	(%rsi,%r9,4), %xmm1
	vfmadd213ss	(%r10), %xmm3, %xmm1
	vfmadd231ss	(%rsi,%rdi,4), %xmm0, %xmm1
	vmovss	%xmm1, (%r10)
	cmpl	%r8d, %eax
	jle	.L4
	leal	(%rdx,%r8), %edi
	movslq	%edi, %rdi
	leaq	(%r14,%rdi,4), %r9
	leal	(%r15,%r8), %edi
	addl	%r11d, %r8d
	vmovss	(%r9), %xmm6
	movslq	%edi, %rdi
	vfmadd132ss	(%rsi,%rdi,4), %xmm6, %xmm3
	movslq	%r8d, %rdi
	vfmadd132ss	(%rsi,%rdi,4), %xmm3, %xmm0
	vmovss	%xmm0, (%r9)
.L4:
	movl	-84(%rsp), %edx
	addq	$8, %rbx
	addl	%edx, -32(%rsp)
	addl	%edx, %r11d
	movq	-96(%rsp), %rdx
	addq	%rdx, %rcx
	movl	-28(%rsp), %edx
	leal	2(%rdx), %edi
	movl	-52(%rsp), %edx
	cmpl	%edx, %edi
	je	.L40
	cmpl	$6, -12(%rsp)
	vmovss	-4(%rbx), %xmm3
	movl	%edi, -28(%rsp)
	ja	.L41
.L22:
	xorl	%edi, %edi
	xorl	%r8d, %r8d
	jmp	.L15
.L40:
	movl	-80(%rsp), %r8d
	movl	-28(%rsp), %ebx
	movq	-40(%rsp), %rdx
	movl	-76(%rsp), %edi
	movq	-48(%rsp), %r15
	leal	1(%rbx,%r8), %ebx
.L19:
	movslq	%ebx, %r11
	imull	%eax, %ebx
	movl	%edi, -28(%rsp)
	movl	%r8d, -40(%rsp)
	movslq	%ebx, %r10
	.p2align 4
	.p2align 3
.L13:
	cmpl	$6, -12(%rsp)
	movq	-8(%rsp), %rdi
	vmovss	(%rdi,%r11,4), %xmm1
	jbe	.L21
	leaq	(%rsi,%r10,4), %rdi
	vbroadcastss	%xmm1, %ymm2
	xorl	%ecx, %ecx
.L9:
	vmovups	(%rdi,%rcx), %ymm0
	vfmadd213ps	(%rdx,%rcx), %ymm2, %ymm0
	vmovups	%ymm0, (%rdx,%rcx)
	addq	$32, %rcx
	cmpq	%rcx, %r12
	jne	.L9
	cmpl	%eax, %r13d
	je	.L10
	movl	%r13d, %ecx
	movl	%r13d, %edi
.L8:
	movl	%eax, %r8d
	subl	%ecx, %r8d
	leal	-1(%r8), %r9d
	cmpl	$2, %r9d
	jbe	.L11
	leaq	(%rcx,%r15), %r9
	addq	%r10, %rcx
	vshufps	$0, %xmm1, %xmm1, %xmm0
	leaq	(%r14,%r9,4), %r9
	vmovups	(%r9), %xmm4
	vfmadd132ps	(%rsi,%rcx,4), %xmm4, %xmm0
	movl	%r8d, %ecx
	andl	$-4, %ecx
	addl	%ecx, %edi
	andl	$3, %r8d
	vmovups	%xmm0, (%r9)
	je	.L10
.L11:
	movl	-16(%rsp), %r9d
	leal	(%r9,%rdi), %ecx
	movslq	%ecx, %rcx
	leaq	(%r14,%rcx,4), %r8
	leal	(%rbx,%rdi), %ecx
	movslq	%ecx, %rcx
	vmovss	(%rsi,%rcx,4), %xmm0
	leal	1(%rdi), %ecx
	vfmadd213ss	(%r8), %xmm1, %xmm0
	vmovss	%xmm0, (%r8)
	cmpl	%ecx, %eax
	jle	.L10
	leal	(%r9,%rcx), %r8d
	addl	%ebx, %ecx
	addl	$2, %edi
	movslq	%r8d, %r8
	movslq	%ecx, %rcx
	leaq	(%r14,%r8,4), %r8
	vmovss	(%rsi,%rcx,4), %xmm0
	vfmadd213ss	(%r8), %xmm1, %xmm0
	vmovss	%xmm0, (%r8)
	cmpl	%edi, %eax
	jle	.L10
	leal	(%r9,%rdi), %ecx
	addl	%ebx, %edi
	movslq	%ecx, %rcx
	movslq	%edi, %rdi
	leaq	(%r14,%rcx,4), %rcx
	vmovss	(%rcx), %xmm7
	vfmadd132ss	(%rsi,%rdi,4), %xmm7, %xmm1
	vmovss	%xmm1, (%rcx)
	.p2align 4
	.p2align 3
.L10:
	movq	-24(%rsp), %rdi
	incq	%r11
	addl	%eax, %ebx
	addq	%rdi, %r10
	cmpl	%r11d, %eax
	jg	.L13
	movq	-72(%rsp), %rbx
	movl	-28(%rsp), %edi
	addq	%rbx, -8(%rsp)
	movl	-40(%rsp), %r8d
	addl	%eax, -16(%rsp)
	addq	%rbx, %rdx
	movq	-24(%rsp), %rbx
	incl	%edi
	subl	%eax, %r8d
	addq	%rbx, %r15
	cmpl	%edi, %eax
	jne	.L3
	vzeroupper
.L37:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4
	.p2align 3
.L21:
	.cfi_restore_state
	xorl	%ecx, %ecx
	xorl	%edi, %edi
	jmp	.L8
	.cfi_endproc
.LFE58:
	.size	matmul_wrap, .-matmul_wrap
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%s/%s.bin"
.LC1:
	.string	"rb"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"cannot open %s \342\200\224 run common/gen_inputs.py first\n"
	.section	.rodata.str1.1
.LC3:
	.string	"short read on %s\n"
	.text
	.p2align 4
	.type	load_matrix, @function
load_matrix:
.LFB54:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r9
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	leaq	.LC0(%rip), %r8
	movl	$512, %ecx
	subq	$528, %rsp
	.cfi_def_cfa_offset 576
	movslq	%edx, %rbx
	movl	$2, %edx
	movq	%fs:40, %rax
	movq	%rax, 520(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %r13
	subq	$8, %rsp
	.cfi_def_cfa_offset 584
	pushq	%rsi
	.cfi_def_cfa_offset 592
	movq	%r13, %rdi
	movl	$512, %esi
	call	__snprintf_chk@PLT
	leaq	.LC1(%rip), %rsi
	movq	%r13, %rdi
	call	fopen@PLT
	movq	%r13, %rsp
	.cfi_def_cfa_offset 576
	testq	%rax, %rax
	je	.L48
	imulq	%rbx, %rbx
	movq	%rax, %rbp
	leaq	0(,%rbx,4), %r14
	movq	%r14, %rdi
	call	malloc@PLT
	movq	%rbp, %r8
	movq	%rbx, %rcx
	movl	$4, %edx
	movq	%r14, %rsi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	__fread_chk@PLT
	cmpq	%rax, %rbx
	jne	.L49
	movq	%rbp, %rdi
	call	fclose@PLT
	movq	520(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L50
	addq	$528, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	movq	%r12, %rax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L48:
	.cfi_restore_state
	movq	%r13, %rcx
	leaq	.LC2(%rip), %rdx
.L47:
	movq	stderr(%rip), %rdi
	movl	$2, %esi
	xorl	%eax, %eax
	call	__fprintf_chk@PLT
	movl	$1, %edi
	call	exit@PLT
.L50:
	call	__stack_chk_fail@PLT
.L49:
	movq	%r13, %rcx
	leaq	.LC3(%rip), %rdx
	jmp	.L47
	.cfi_endproc
.LFE54:
	.size	load_matrix, .-load_matrix
	.section	.rodata.str1.1
.LC6:
	.string	"PASS"
.LC7:
	.string	"FAIL"
.LC8:
	.string	"data/N%d"
.LC9:
	.string	"A"
.LC10:
	.string	"B"
.LC11:
	.string	"C_ref"
.LC16:
	.string	"name,N,seconds,gflops,check"
.LC17:
	.string	"rung4_c_simd"
.LC18:
	.string	"%s,%d,%.4f,%.2f,%s\n"
	.text
	.p2align 4
	.type	harness_main.constprop.0, @function
harness_main.constprop.0:
.LFB61:
	.cfi_startproc
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp
	pushq	-8(%r10)
	pushq	%rbp
	movq	%rsp, %rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	pushq	%rbx
	movl	$1024, %r12d
	subq	$448, %rsp
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	cmpl	$1, %edi
	jg	.L113
.L52:
	leaq	-320(%rbp), %rbx
	movl	%r12d, %r9d
	leaq	.LC8(%rip), %r8
	movl	$256, %ecx
	movl	$2, %edx
	movl	$256, %esi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	call	__snprintf_chk@PLT
	movl	%r12d, %edx
	leaq	.LC9(%rip), %rsi
	movq	%rbx, %rdi
	call	load_matrix
	movl	%r12d, %edx
	leaq	.LC10(%rip), %rsi
	movq	%rbx, %rdi
	movq	%rax, -400(%rbp)
	call	load_matrix
	movl	%r12d, %edx
	leaq	.LC11(%rip), %rsi
	movq	%rbx, %rdi
	movslq	%r12d, %r13
	movq	%rax, -344(%rbp)
	call	load_matrix
	movq	%r13, -360(%rbp)
	movq	%rax, %r14
	movq	%r13, %rax
	imulq	%r13, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	movq	%rax, -456(%rbp)
	call	malloc@PLT
	movl	$3, -444(%rbp)
	movq	-344(%rbp), %r10
	movq	%rax, %r15
.L79:
	movq	-360(%rbp), %rax
	vmovsd	.LC4(%rip), %xmm0
	movl	%r12d, %ebx
	movq	%r14, -488(%rbp)
	andl	$-8, %ebx
	movq	%r13, -496(%rbp)
	movl	$0, -432(%rbp)
	movq	%r15, %r13
	movl	%ebx, %r14d
	movq	%r10, %rbx
	salq	$2, %rax
	movq	%rax, -416(%rbp)
	leal	(%r12,%r12), %eax
	movl	%eax, -428(%rbp)
	cltq
	movq	%rax, -440(%rbp)
	leal	-1(%r12), %eax
	movl	%eax, -344(%rbp)
	movl	%r12d, %eax
	shrl	$3, %eax
	salq	$5, %rax
	movq	%rax, -480(%rbp)
	leaq	-336(%rbp), %rax
	movq	%rax, -464(%rbp)
	leal	-3(%r12), %eax
	andl	$-2, %eax
	addl	$3, %eax
	movl	%eax, -408(%rbp)
.L73:
	movq	-456(%rbp), %rcx
	xorl	%esi, %esi
	movq	%r13, %rdi
	vmovsd	%xmm0, -352(%rbp)
	movq	%rcx, %rdx
	call	__memset_chk@PLT
	movq	-464(%rbp), %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	vxorpd	%xmm7, %xmm7, %xmm7
	testl	%r12d, %r12d
	vmovsd	-352(%rbp), %xmm0
	vcvtsi2sdq	-328(%rbp), %xmm7, %xmm1
	vmovsd	%xmm1, %xmm1, %xmm2
	vcvtsi2sdq	-336(%rbp), %xmm7, %xmm1
	vfmadd132sd	.LC12(%rip), %xmm1, %xmm2
	vmovsd	%xmm2, -472(%rbp)
	jle	.L54
	movq	-400(%rbp), %r11
	movq	%r13, %rax
	xorl	%r15d, %r15d
	xorl	%edi, %edi
	movl	$0, -364(%rbp)
	xorl	%ecx, %ecx
	movq	%r11, -392(%rbp)
	movq	-480(%rbp), %r11
.L55:
	xorl	%r10d, %r10d
	cmpl	$2, %r12d
	jle	.L71
	movl	-364(%rbp), %esi
	movl	%r12d, %r9d
	movl	$0, -368(%rbp)
	movq	%rax, -376(%rbp)
	movl	%ecx, -420(%rbp)
	movq	%r15, -384(%rbp)
	movl	%edi, -424(%rbp)
	leal	1(%rsi), %edx
	movl	%edx, -352(%rbp)
	movq	-392(%rbp), %rdx
	leaq	4(%rdx), %r10
	movl	-408(%rbp), %edx
	vmovss	-4(%r10), %xmm4
	addl	%edx, %esi
	xorl	%edx, %edx
	cmpl	$6, -344(%rbp)
	movl	%esi, -404(%rbp)
	jbe	.L85
.L115:
	vbroadcastss	(%r10), %ymm2
	movq	-376(%rbp), %rax
	movslq	%r9d, %rcx
	leaq	(%rbx,%rdx,4), %rdi
	leaq	(%rbx,%rcx,4), %rsi
	vbroadcastss	%xmm4, %ymm3
	xorl	%ecx, %ecx
	.p2align 4
	.p2align 3
.L68:
	vmovups	(%rdi,%rcx), %ymm1
	vfmadd213ps	(%rax,%rcx), %ymm3, %ymm1
	vfmadd231ps	(%rsi,%rcx), %ymm2, %ymm1
	vmovups	%ymm1, (%rax,%rcx)
	addq	$32, %rcx
	cmpq	%r11, %rcx
	jne	.L68
	movq	%rax, -376(%rbp)
	cmpl	%r14d, %r12d
	je	.L56
	movl	%r14d, %ecx
	movl	%r14d, %esi
.L67:
	movl	%r12d, %r8d
	subl	%ecx, %r8d
	leal	-1(%r8), %edi
	cmpl	$2, %edi
	jbe	.L57
	movq	-384(%rbp), %rdi
	movq	-400(%rbp), %rax
	vshufps	$0, %xmm4, %xmm4, %xmm2
	addq	%rcx, %rdi
	leaq	0(%r13,%rdi,4), %r15
	movslq	%r9d, %rdi
	addq	%rcx, %rdi
	vmovups	(%r15), %xmm6
	addq	%rdx, %rcx
	vfmadd132ps	(%rbx,%rcx,4), %xmm6, %xmm2
	movslq	-352(%rbp), %rcx
	vbroadcastss	(%rax,%rcx,4), %xmm1
	movl	%r8d, %ecx
	vfmadd132ps	(%rbx,%rdi,4), %xmm2, %xmm1
	andl	$-4, %ecx
	addl	%ecx, %esi
	andl	$3, %r8d
	vmovups	%xmm1, (%r15)
	je	.L56
.L57:
	movl	-364(%rbp), %eax
	movl	-368(%rbp), %r15d
	vmovss	(%r10), %xmm1
	leal	(%rax,%rsi), %ecx
	movslq	%ecx, %rcx
	leaq	0(%r13,%rcx,4), %rdi
	leal	(%r15,%rsi), %ecx
	movslq	%ecx, %rcx
	vmovss	(%rbx,%rcx,4), %xmm2
	leal	(%r9,%rsi), %ecx
	vfmadd213ss	(%rdi), %xmm4, %xmm2
	movslq	%ecx, %rcx
	vfmadd231ss	(%rbx,%rcx,4), %xmm1, %xmm2
	leal	1(%rsi), %ecx
	vmovss	%xmm2, (%rdi)
	cmpl	%r12d, %ecx
	jge	.L56
	leal	(%rax,%rcx), %edi
	addl	$2, %esi
	movslq	%edi, %rdi
	leaq	0(%r13,%rdi,4), %r8
	leal	(%r15,%rcx), %edi
	addl	%r9d, %ecx
	movslq	%edi, %rdi
	movslq	%ecx, %rcx
	vmovss	(%rbx,%rdi,4), %xmm2
	vfmadd213ss	(%r8), %xmm4, %xmm2
	vfmadd231ss	(%rbx,%rcx,4), %xmm1, %xmm2
	vmovss	%xmm2, (%r8)
	cmpl	%esi, %r12d
	jle	.L56
	leal	(%rax,%rsi), %ecx
	movslq	%ecx, %rcx
	leaq	0(%r13,%rcx,4), %rdi
	leal	(%r15,%rsi), %ecx
	addl	%r9d, %esi
	vmovss	(%rdi), %xmm7
	movslq	%ecx, %rcx
	vfmadd132ss	(%rbx,%rcx,4), %xmm7, %xmm4
	movslq	%esi, %rcx
	vfmadd132ss	(%rbx,%rcx,4), %xmm4, %xmm1
	vmovss	%xmm1, (%rdi)
.L56:
	movl	-428(%rbp), %eax
	addq	$8, %r10
	addl	%eax, -368(%rbp)
	addl	%eax, %r9d
	movq	-440(%rbp), %rax
	addq	%rax, %rdx
	movl	-352(%rbp), %eax
	leal	2(%rax), %ecx
	cmpl	%ecx, -404(%rbp)
	je	.L114
	cmpl	$6, -344(%rbp)
	vmovss	-4(%r10), %xmm4
	movl	%ecx, -352(%rbp)
	ja	.L115
.L85:
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	jmp	.L67
.L114:
	movl	-424(%rbp), %edi
	movl	%eax, %esi
	movl	-420(%rbp), %ecx
	movq	-376(%rbp), %rax
	movq	-384(%rbp), %r15
	leal	1(%rdi,%rsi), %r10d
.L71:
	movslq	%r10d, %r9
	movq	%r11, -352(%rbp)
	movq	-392(%rbp), %r11
	movl	%ecx, -376(%rbp)
	imull	%r12d, %r10d
	movl	%edi, -384(%rbp)
	movslq	%r10d, %r8
	.p2align 4
	.p2align 3
.L65:
	cmpl	$6, -344(%rbp)
	vmovss	(%r11,%r9,4), %xmm2
	jbe	.L84
	leaq	(%rbx,%r8,4), %rcx
	vbroadcastss	%xmm2, %ymm3
	xorl	%edx, %edx
.L61:
	vmovups	(%rcx,%rdx), %ymm1
	vfmadd213ps	(%rax,%rdx), %ymm3, %ymm1
	vmovups	%ymm1, (%rax,%rdx)
	addq	$32, %rdx
	cmpq	%rdx, -352(%rbp)
	jne	.L61
	cmpl	%r14d, %r12d
	je	.L62
	movl	%r14d, %edx
	movl	%r14d, %ecx
.L60:
	movl	%r12d, %esi
	subl	%edx, %esi
	leal	-1(%rsi), %edi
	cmpl	$2, %edi
	jbe	.L63
	leaq	(%rdx,%r15), %rdi
	addq	%r8, %rdx
	vshufps	$0, %xmm2, %xmm2, %xmm1
	leaq	0(%r13,%rdi,4), %rdi
	vmovups	(%rdi), %xmm5
	vfmadd132ps	(%rbx,%rdx,4), %xmm5, %xmm1
	movl	%esi, %edx
	andl	$-4, %edx
	addl	%edx, %ecx
	andl	$3, %esi
	vmovups	%xmm1, (%rdi)
	je	.L62
.L63:
	movl	-364(%rbp), %edi
	leal	(%rdi,%rcx), %edx
	movslq	%edx, %rdx
	leaq	0(%r13,%rdx,4), %rsi
	leal	(%r10,%rcx), %edx
	movslq	%edx, %rdx
	vmovss	(%rbx,%rdx,4), %xmm1
	leal	1(%rcx), %edx
	vfmadd213ss	(%rsi), %xmm2, %xmm1
	vmovss	%xmm1, (%rsi)
	cmpl	%r12d, %edx
	jge	.L62
	leal	(%rdi,%rdx), %esi
	addl	%r10d, %edx
	addl	$2, %ecx
	movslq	%esi, %rsi
	movslq	%edx, %rdx
	leaq	0(%r13,%rsi,4), %rsi
	vmovss	(%rbx,%rdx,4), %xmm1
	vfmadd213ss	(%rsi), %xmm2, %xmm1
	vmovss	%xmm1, (%rsi)
	cmpl	%ecx, %r12d
	jle	.L62
	leal	(%rdi,%rcx), %edx
	addl	%r10d, %ecx
	movslq	%edx, %rdx
	leaq	0(%r13,%rdx,4), %rsi
	movslq	%ecx, %rdx
	vmovss	(%rsi), %xmm7
	vfmadd132ss	(%rbx,%rdx,4), %xmm7, %xmm2
	vmovss	%xmm2, (%rsi)
	.p2align 4
	.p2align 3
.L62:
	movq	-360(%rbp), %rsi
	incq	%r9
	addl	%r12d, %r10d
	addq	%rsi, %r8
	cmpl	%r9d, %r12d
	jg	.L65
	movq	-416(%rbp), %rsi
	movl	-376(%rbp), %ecx
	addq	%rsi, -392(%rbp)
	movl	-384(%rbp), %edi
	addl	%r12d, -364(%rbp)
	movq	-352(%rbp), %r11
	addq	%rsi, %rax
	movq	-360(%rbp), %rsi
	incl	%ecx
	subl	%r12d, %edi
	addq	%rsi, %r15
	cmpl	%r12d, %ecx
	jne	.L55
	vzeroupper
.L54:
	movq	-464(%rbp), %rsi
	movl	$1, %edi
	vmovsd	%xmm0, -352(%rbp)
	call	clock_gettime@PLT
	vxorpd	%xmm7, %xmm7, %xmm7
	vmovsd	-352(%rbp), %xmm0
	vcvtsi2sdq	-328(%rbp), %xmm7, %xmm1
	vcvtsi2sdq	-336(%rbp), %xmm7, %xmm2
	vfmadd132sd	.LC12(%rip), %xmm2, %xmm1
	incl	-432(%rbp)
	movl	-432(%rbp), %eax
	movl	-444(%rbp), %ecx
	vsubsd	-472(%rbp), %xmm1, %xmm1
	vminsd	%xmm0, %xmm1, %xmm0
	cmpl	%ecx, %eax
	jne	.L73
	movq	%r13, %r15
	movq	-488(%rbp), %r14
	movq	-496(%rbp), %r13
	movq	%rbx, %r10
.L53:
	vxorpd	%xmm7, %xmm7, %xmm7
	movq	%r13, %rdx
	leaq	.LC6(%rip), %rbx
	vcvtsi2sdl	%r12d, %xmm7, %xmm2
	vaddsd	%xmm2, %xmm2, %xmm1
	imulq	%r13, %rdx
	vmulsd	%xmm2, %xmm1, %xmm1
	vmulsd	%xmm2, %xmm1, %xmm1
	vdivsd	%xmm0, %xmm1, %xmm1
	vdivsd	.LC13(%rip), %xmm1, %xmm1
	testq	%rdx, %rdx
	jle	.L74
	vxorps	%xmm3, %xmm3, %xmm3
	xorl	%eax, %eax
	vmovss	.LC14(%rip), %xmm4
.L76:
	vmovss	(%r15,%rax,4), %xmm2
	vsubss	(%r14,%rax,4), %xmm2, %xmm2
	incq	%rax
	vandps	%xmm4, %xmm2, %xmm2
	vmaxss	%xmm3, %xmm2, %xmm3
	cmpq	%rax, %rdx
	jne	.L76
	vmovss	.LC15(%rip), %xmm2
	leaq	.LC6(%rip), %rbx
	leaq	.LC7(%rip), %rax
	vcomiss	%xmm3, %xmm2
	cmovbe	%rax, %rbx
.L74:
	leaq	.LC16(%rip), %rdi
	movq	%r10, -360(%rbp)
	vmovsd	%xmm0, -352(%rbp)
	vmovsd	%xmm1, -344(%rbp)
	call	puts@PLT
	vmovsd	-344(%rbp), %xmm1
	movq	%rbx, %r8
	movl	%r12d, %ecx
	vmovsd	-352(%rbp), %xmm0
	leaq	.LC17(%rip), %rdx
	leaq	.LC18(%rip), %rsi
	movl	$2, %edi
	movl	$2, %eax
	call	__printf_chk@PLT
	movq	-400(%rbp), %rdi
	call	free@PLT
	movq	-360(%rbp), %rdi
	call	free@PLT
	movq	%r14, %rdi
	call	free@PLT
	movq	%r15, %rdi
	call	free@PLT
	cmpl	$1397965136, (%rbx)
	je	.L116
.L77:
	movl	$1, %eax
.L78:
	movq	-56(%rbp), %rdx
	subq	%fs:40, %rdx
	jne	.L117
	addq	$448, %rsp
	popq	%rbx
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
	.p2align 4
	.p2align 3
.L84:
	.cfi_restore_state
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	jmp	.L60
.L113:
	movl	%edi, %r13d
	movq	8(%rsi), %rdi
	movq	%rsi, %r14
	movl	$10, %edx
	xorl	%esi, %esi
	call	strtol@PLT
	movq	%rax, %rbx
	movl	%eax, %r12d
	cmpl	$2, %r13d
	je	.L52
	movq	16(%r14), %rdi
	xorl	%esi, %esi
	movl	$10, %edx
	leaq	-320(%rbp), %r13
	call	strtol@PLT
	movl	%ebx, %r9d
	leaq	.LC8(%rip), %r8
	movl	$256, %ecx
	movl	%eax, -444(%rbp)
	movq	%rax, -352(%rbp)
	movl	$2, %edx
	movl	$256, %esi
	movq	%r13, %rdi
	xorl	%eax, %eax
	call	__snprintf_chk@PLT
	movl	%ebx, %edx
	leaq	.LC9(%rip), %rsi
	movq	%r13, %rdi
	call	load_matrix
	movl	%ebx, %edx
	leaq	.LC10(%rip), %rsi
	movq	%r13, %rdi
	movq	%rax, -400(%rbp)
	call	load_matrix
	movl	%ebx, %edx
	leaq	.LC11(%rip), %rsi
	movq	%r13, %rdi
	movq	%rax, -344(%rbp)
	call	load_matrix
	movq	%rax, %r14
	movslq	%ebx, %rax
	movq	%rax, -360(%rbp)
	movq	%rax, %rbx
	imulq	%rax, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	movq	%rax, -456(%rbp)
	call	malloc@PLT
	movq	-352(%rbp), %r11
	movq	-344(%rbp), %r10
	movq	%rax, %r15
	testl	%r11d, %r11d
	jg	.L118
	vmovsd	.LC4(%rip), %xmm0
	movslq	%r12d, %r13
	jmp	.L53
.L116:
	xorl	%eax, %eax
	cmpb	$0, 4(%rbx)
	je	.L78
	jmp	.L77
.L118:
	movq	%rbx, %r13
	jmp	.L79
.L117:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE61:
	.size	harness_main.constprop.0, .-harness_main.constprop.0
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB59:
	.cfi_startproc
	endbr64
	jmp	harness_main.constprop.0
	.cfi_endproc
.LFE59:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC4:
	.long	966823146
	.long	1177108057
	.align 8
.LC12:
	.long	-400107883
	.long	1041313291
	.align 8
.LC13:
	.long	0
	.long	1104006501
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC14:
	.long	2147483647
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC15:
	.long	1008981770
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
