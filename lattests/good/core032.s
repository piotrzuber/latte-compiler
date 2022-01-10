.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $42
    popl %eax
    neg %eax
    pushl %eax
    pushl $1
    popl %eax
    neg %eax
    pushl %eax
    popl %ebx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ebx
    pushl %eax
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
