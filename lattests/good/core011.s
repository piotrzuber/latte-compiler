.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    popl %eax
    neg %eax
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
