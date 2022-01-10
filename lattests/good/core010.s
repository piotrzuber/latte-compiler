.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $5
    call fac
    popl %ebx
    pushl %eax
    call printInt
    popl %ebx
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
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
L1:
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
    jnz L0
    jmp L2
L0:
    leal -4(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    pushl $1
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    jmp L1
L2:
    pushl -4(%ebp)
    popl %eax
    leave
    ret
