.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $28, %esp
    pushl $4
    pushl $10
    call calloc
    popl %edx
    popl %ecx
    pushl %edx
    pushl %eax
    popl -8(%ebp)
    popl -4(%ebp)
    pushl $0
    popl -12(%ebp)
L0:
    pushl -12(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L3
    pushl $1
    jmp L4
L3:
    pushl $0
L4:
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L2
L1:
    leal -8(%ebp), %eax
    pushl %eax
    pushl -12(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    pushl -12(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L0
L2:
    pushl $0
    popl -16(%ebp)
L5:
    pushl -16(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L8
    pushl $1
    jmp L9
L8:
    pushl $0
L9:
    popl %eax
    testl %eax, %eax
    jnz L6
    jmp L7
L6:
    leal -8(%ebp), %eax
    pushl %eax
    pushl -16(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    call printInt
    addl $4, %esp
    leal -16(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L5
L7:
    pushl $0
    popl -20(%ebp)
L10:
    pushl -20(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L13
    pushl $1
    jmp L14
L13:
    pushl $0
L14:
    popl %eax
    testl %eax, %eax
    jnz L11
    jmp L12
L11:
    leal -8(%ebp), %eax
    pushl %eax
    pushl -20(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl -24(%ebp)
    pushl -24(%ebp)
    call printInt
    addl $4, %esp
    leal -20(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L10
L12:
    pushl $45
    popl -20(%ebp)
    pushl -20(%ebp)
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
