.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $17
    popl -4(%ebp)
L1:
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
    jnz L0
    jmp L2
L0:
    leal -4(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    pushl $2
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
    jnz L6
    jmp L5
L6:
    pushl $0
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
    jmp L7
L5:
    pushl $1
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
L7:
    leave
