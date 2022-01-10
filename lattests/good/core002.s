.globl main

LStr0:
.string "foo"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    call foo
    pushl $0
    popl %eax
    leave
    ret
foo:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr0
    call printString
    popl %ebx
    leave
    ret
