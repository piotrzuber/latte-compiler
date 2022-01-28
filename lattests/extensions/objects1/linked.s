.globl main


.Node_vtable: .int Node$setElem,Node$setNext,Node$getElem,Node$getNext
.Stack_vtable: .int Stack$push,Stack$isEmpty,Stack$top,Stack$pop
Node$setElem:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
Node$setNext:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
Node$getElem:
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
Node$getNext:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    popl %eax
    leave
    ret
Stack$push:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $4
    pushl $12
    call calloc
    popl %ecx
    popl %ecx
    movl $.Node_vtable, (%eax)
    pushl %eax
    popl -4(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl 8(%ebp)
    call *0(%edx)
    addl $4, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    call *4(%edx)
    addl $4, %esp
    popl %ecx
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    pushl -4(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
Stack$isEmpty:
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
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jne L0
    pushl $1
    jmp L1
L0:
    pushl $0
L1:
    popl %eax
    leave
    ret
Stack$top:
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
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *8(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    popl %eax
    leave
    ret
Stack$pop:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *12(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $4
    pushl $8
    call calloc
    popl %ecx
    popl %ecx
    movl $.Stack_vtable, (%eax)
    pushl %eax
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
L2:
    pushl -8(%ebp)
    pushl $10
    popl %eax
    cmpl %eax, 0(%esp)
    jge L5
    pushl $1
    jmp L6
L5:
    pushl $0
L6:
    popl %eax
    testl %eax, %eax
    jnz L3
    jmp L4
L3:
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl -8(%ebp)
    call *0(%edx)
    addl $4, %esp
    popl %ecx
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L2
L4:
L7:
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
    popl %eax
    testl %eax, %eax
    jnz L9
    jmp L8
L8:
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *8(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    call printInt
    addl $4, %esp
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *12(%edx)
    addl $0, %esp
    popl %ecx
    jmp L7
L9:
    pushl $0
    popl %eax
    leave
    ret
