.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    pushl $1
    popl %eax
    neg %eax
    pushl %eax
    call f
    addl $8, %esp
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 12(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jle L5
    pushl $1
    jmp L6
L5:
    pushl $0
L6:
    popl %eax
    testl %eax, %eax
    jnz L4
    jmp L3
L4:
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jle L7
    pushl $1
    jmp L8
L7:
    pushl $0
L8:
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L3
L3:
    pushl 12(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jge L10
    pushl $1
    jmp L11
L10:
    pushl $0
L11:
    popl %eax
    testl %eax, %eax
    jnz L9
    jmp L1
L9:
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jge L12
    pushl $1
    jmp L13
L12:
    pushl $0
L13:
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $7
    popl %eax
    leave
    ret
    jmp L2
L1:
    pushl $42
    popl %eax
    leave
    ret
L2:
    leave
    ret
