.globl main


f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $0
    popl %eax
    leave
    ret
    jmp L2
L1:
L2:
    leave
    ret
g:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $0
    popl %eax
    testl %eax, %eax
    jnz L3
    jmp L4
L3:
    jmp L5
L4:
    pushl $0
    popl %eax
    leave
    ret
L5:
    leave
    ret
p:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leave
    ret
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    call p
    addl $0, %esp
    pushl $0
    popl %eax
    leave
    ret
