.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $5
    call fac
    addl $4, %esp
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
fac:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $0
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl $1
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
L0:
    pushl -8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jle L3
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
    leal -4(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    imul %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    pushl $1
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    jmp L0
L2:
    pushl -4(%ebp)
    popl %eax
    leave
    ret
