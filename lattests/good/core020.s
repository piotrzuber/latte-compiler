.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    call p
    addl $0, %esp
    pushl $1
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
p:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leave
    ret
