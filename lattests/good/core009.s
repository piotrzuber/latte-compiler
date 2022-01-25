.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    call foo
    addl $0, %esp
    pushl %eax
    popl -4(%ebp)
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
foo:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $10
    popl %eax
    leave
    ret
