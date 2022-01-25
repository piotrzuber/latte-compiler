.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $17
    popl -4(%ebp)
L0:
    pushl -4(%ebp)
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
    pushl $2
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
    pushl $0
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
    jnz L5
    jmp L6
L5:
    pushl $0
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
    jmp L7
L6:
    pushl $1
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
L7:
    leave
    ret
