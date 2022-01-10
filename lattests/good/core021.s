.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L0
L1:
    pushl $1
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
L0:
    leave
