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
    jnz L1
    jmp L2
L2:
    call e
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L0
L1:
    pushl $LStr0
    call printString
    popl %ebx
L0:
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
