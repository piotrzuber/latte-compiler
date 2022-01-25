.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp
    call readInt
    addl $0, %esp
    pushl %eax
    popl -4(%ebp)
    call readString
    addl $0, %esp
    pushl %eax
    popl -8(%ebp)
    call readString
    addl $0, %esp
    pushl %eax
    popl -12(%ebp)
    pushl -4(%ebp)
    pushl $5
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    call printInt
    addl $4, %esp
    pushl -12(%ebp)
    pushl -8(%ebp)
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    call printString
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
