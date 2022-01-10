.globl main

LStr0:
.string "yes"
LStr1:
.string "NOOO"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    pushl $2
    call f
    popl %ebx
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L2
L2:
    call e
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $LStr0
    call printString
    popl %ebx
L1:
    leave
e:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr1
    call printString
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
