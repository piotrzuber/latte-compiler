.globl main


d:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $0
    popl %eax
    leave
    ret
s:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl $1
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    leave
    ret
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    call d
    addl $0, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call s
    addl $4, %esp
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
