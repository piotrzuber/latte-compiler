.globl main


.Counter_vtable: .int Counter$incr,Counter$value
main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $0
    popl -4(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl $4
    pushl $8
    call calloc
    popl %ecx
    popl %ecx
    movl $.Counter_vtable, (%eax)
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *0(%edx)
    addl $0, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *0(%edx)
    addl $0, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *0(%edx)
    addl $0, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *4(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    popl -8(%ebp)
    pushl -8(%ebp)
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
Counter$incr:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    leave
    ret
Counter$value:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    popl %eax
    leave
    ret
