.globl main


.IntQueue_vtable: .int IntQueue$isEmpty,IntQueue$insert,IntQueue$first,IntQueue$rmFirst,IntQueue$size
.Node_vtable: .int Node$setElem,Node$setNext,Node$getElem,Node$getNext
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
IntQueue$isEmpty:
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
IntQueue$insert:
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
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *0(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L2
    jmp L3
L2:
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
    jmp L4
L3:
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl -4(%ebp)
    call *4(%edx)
    addl $4, %esp
    popl %ecx
L4:
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    pushl -4(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
IntQueue$first:
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
IntQueue$rmFirst:
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
IntQueue$size:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
L5:
    pushl -4(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    je L8
    pushl $1
    jmp L9
L8:
    pushl $0
L9:
    popl %eax
    testl %eax, %eax
    jnz L6
    jmp L7
L6:
    leal -4(%ebp), %eax
    pushl %eax
    leal -4(%ebp), %eax
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
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L5
L7:
    pushl -8(%ebp)
    popl %eax
    leave
    ret
f:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    imul %ecx, %eax
    pushl %eax
    pushl $3
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
    subl $4, %esp
    pushl $4
    pushl $12
    call calloc
    popl %ecx
    popl %ecx
    movl $.IntQueue_vtable, (%eax)
    pushl %eax
    popl -4(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $3
    call f
    addl $4, %esp
    pushl %eax
    call *4(%edx)
    addl $4, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $5
    call *4(%edx)
    addl $4, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $7
    call *4(%edx)
    addl $4, %esp
    popl %ecx
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
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *16(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
