.globl main

LStr0:
.string "fun"
LStr1:
.string "bub"

main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $LStr0
    popl -4(%ebp)
    pushl $LStr1
    popl -8(%ebp)
    pushl -8(%ebp)
    pushl -4(%ebp)
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    call printString
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
