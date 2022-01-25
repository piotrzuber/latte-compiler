.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    pushl $1
    popl %eax
    cmpl %eax, 0(%esp)
    jne L2
    pushl $1
    jmp L3
L2:
    pushl $0
L3:
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $42
    call printInt
    addl $4, %esp
L1:
    pushl $0
    popl %eax
    leave
    ret
