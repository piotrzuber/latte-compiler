.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $0
    popl -4(%ebp)
    pushl $56
    popl -8(%ebp)
    pushl -8(%ebp)
    pushl $45
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl $2
    popl %eax
    cmpl %eax, 0(%esp)
    jg L3
    pushl $1
    jmp L4
L3:
    pushl $0
L4:
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    leal -4(%ebp), %eax
    pushl %eax
    pushl $1
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    jmp L2
L1:
    leal -4(%ebp), %eax
    pushl %eax
    pushl $2
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
L2:
    pushl -4(%ebp)
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
