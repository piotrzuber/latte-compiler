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
    popl %ebx
    popl %ebx
    pushl %eax
    call printString
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
