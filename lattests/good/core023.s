.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $56, %esp
    pushl $1
    popl -4(%ebp)
    pushl $2
    popl -8(%ebp)
    pushl $1
    popl -12(%ebp)
    pushl $2
    popl -16(%ebp)
    pushl $1
    popl -20(%ebp)
    pushl $2
    popl -24(%ebp)
    pushl $1
    popl -28(%ebp)
    pushl $2
    popl -32(%ebp)
    pushl $1
    popl -36(%ebp)
    pushl $2
    popl -40(%ebp)
    pushl $1
    popl -44(%ebp)
    pushl $2
    popl -48(%ebp)
    pushl $1
    popl -52(%ebp)
    pushl $2
    popl -56(%ebp)
    pushl -4(%ebp)
    pushl -8(%ebp)
    pushl -12(%ebp)
    pushl -16(%ebp)
    pushl -20(%ebp)
    pushl -24(%ebp)
    pushl -28(%ebp)
    pushl -32(%ebp)
    pushl -36(%ebp)
    pushl -40(%ebp)
    pushl -44(%ebp)
    pushl -48(%ebp)
    pushl -52(%ebp)
    pushl -56(%ebp)
    call foo
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    pushl %eax
    popl %eax
    leave
    ret
foo:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $2
    pushl 60(%ebp)
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    pushl 56(%ebp)
    pushl $2
    popl %ebx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ebx
    pushl %eax
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 52(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 48(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 44(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 40(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 36(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 32(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 28(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 24(%ebp)
    pushl $2
    popl %ebx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ebx
    pushl %eax
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 20(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 16(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 12(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl $10
    popl %ebx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ebx
    pushl %edx
    popl -4(%ebp)
    pushl -4(%ebp)
    call printInt
    popl %ebx
    pushl -4(%ebp)
    popl %eax
    leave
    ret
