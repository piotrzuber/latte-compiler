.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $0
    popl -4(%ebp)
    pushl $7
    popl -8(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl $1234234
    popl %eax
    neg %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
    pushl -8(%ebp)
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
