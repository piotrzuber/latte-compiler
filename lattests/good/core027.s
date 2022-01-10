.globl main

LStr0:
.string "bad"
LStr1:
.string "good"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr0
    call f
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    pushl $LStr1
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    pushl 8(%ebp)
    call printString
    popl %ebx
    leave
