.globl main


f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L0
L1:
    pushl $0
    popl %eax
    leave
    ret
    jmp L2
L0:
L2:
    leave
g:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $0
    popl %eax
    testl %eax, %eax
    jnz L4
    jmp L3
L4:
    jmp L5
L3:
    pushl $0
    popl %eax
    leave
    ret
L5:
    leave
p:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leave
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    call p
    pushl $0
    popl %eax
    leave
    ret
