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
    addl $8, %esp
    pushl $0
    popl %eax
    leave
    ret
f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl 12(%ebp)
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
L2:
    call e
    addl $0, %esp
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $LStr0
    call printString
    addl $4, %esp
L1:
    leave
    ret
e:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr1
    call printString
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
