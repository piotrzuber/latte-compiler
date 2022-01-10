.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    call p
    pushl $1
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
p:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leave
