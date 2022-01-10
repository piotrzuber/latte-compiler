.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp
    pushl $0
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
    pushl $0
    popl -12(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl $1
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -12(%ebp), %eax
    pushl %eax
    pushl $5000000
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    pushl -4(%ebp)
    call printInt
    popl %ebx
L1:
    pushl -8(%ebp)
    pushl -12(%ebp)
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
    jnz L0
    jmp L2
L0:
    pushl -8(%ebp)
    call printInt
    popl %ebx
    leal -8(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -4(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    pushl -4(%ebp)
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    jmp L1
L2:
    pushl $0
    popl %eax
    leave
    ret
