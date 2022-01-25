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
    popl %ecx
    movl %eax, (%ecx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -12(%ebp), %eax
    pushl %eax
    pushl $5000000
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
L0:
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
    jnz L1
    jmp L2
L1:
    pushl -8(%ebp)
    call printInt
    addl $4, %esp
    leal -8(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -4(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    pushl -4(%ebp)
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    jmp L0
L2:
    pushl $0
    popl %eax
    leave
    ret
