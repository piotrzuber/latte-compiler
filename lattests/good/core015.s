.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $17
    call ev
    popl %ebx
    pushl %eax
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
ev:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
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
    jmp L1
L0:
    pushl 8(%ebp)
    pushl $2
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    call ev
    popl %ebx
    pushl %eax
    popl %eax
    leave
    ret
    jmp L2
L1:
    pushl 8(%ebp)
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
    popl %eax
    leave
    ret
    jmp L7
L6:
    pushl $1
    popl %eax
    leave
    ret
L7:
L2:
    leave
