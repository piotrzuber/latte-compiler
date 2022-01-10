.globl main


main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp
    call readInt
    pushl %eax
    popl -4(%ebp)
    call readString
    pushl %eax
    popl -8(%ebp)
    call readString
    pushl %eax
    popl -12(%ebp)
    pushl -4(%ebp)
    pushl $5
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    call printInt
    popl %ebx
    pushl -12(%ebp)
    pushl -8(%ebp)
    call concat
    popl %ebx
    popl %ebx
    pushl %eax
    call printString
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
