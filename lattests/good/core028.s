.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $0
    popl -4(%ebp)
    pushl -4(%ebp)
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
