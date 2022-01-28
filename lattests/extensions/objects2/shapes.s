.globl main

LStr0:
.string "I'm a shape"
LStr1:
.string "I'm just a shape"
LStr2:
.string "I'm really a rectangle"
LStr3:
.string "I'm really a circle"
LStr4:
.string "I'm really a square"
.Circle_vtable: .int Shape$tell,Circle$tellAgain
.Node_vtable: .int Node$setElem,Node$setNext,Node$getElem,Node$getNext
.Rectangle_vtable: .int Shape$tell,Rectangle$tellAgain
.Shape_vtable: .int Shape$tell,Shape$tellAgain
.Square_vtable: .int Shape$tell,Square$tellAgain
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
Shape$tell:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr0
    call printString
    addl $4, %esp
    leave
    ret
Shape$tellAgain:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr1
    call printString
    addl $4, %esp
    leave
    ret
Rectangle$tellAgain:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr2
    call printString
    addl $4, %esp
    leave
    ret
Circle$tellAgain:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr3
    call printString
    addl $4, %esp
    leave
    ret
Square$tellAgain:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr4
    call printString
    addl $4, %esp
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
    pushl $4
    pushl $4
    call calloc
    popl %ecx
    popl %ecx
    movl $.Shape_vtable, (%eax)
    pushl %eax
    popl -8(%ebp)
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
    pushl $4
    pushl $4
    call calloc
    popl %ecx
    popl %ecx
    movl $.Rectangle_vtable, (%eax)
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
    pushl -8(%ebp)
    call *0(%edx)
    addl $4, %esp
    popl %ecx
    leal -8(%ebp), %eax
    pushl %eax
    pushl $4
    pushl $4
    call calloc
    popl %ecx
    popl %ecx
    movl $.Square_vtable, (%eax)
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
    pushl -8(%ebp)
    call *0(%edx)
    addl $4, %esp
    popl %ecx
    leal -8(%ebp), %eax
    pushl %eax
    pushl $4
    pushl $4
    call calloc
    popl %ecx
    popl %ecx
    movl $.Circle_vtable, (%eax)
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
    pushl -8(%ebp)
    call *0(%edx)
    addl $4, %esp
    popl %ecx
L2:
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
    jnz L4
    jmp L3
L3:
    leal -8(%ebp), %eax
    pushl %eax
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
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *0(%edx)
    addl $0, %esp
    popl %ecx
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *4(%edx)
    addl $0, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *12(%edx)
    addl $0, %esp
    popl %ecx
    jmp L2
L4:
    pushl $0
    popl %eax
    leave
    ret
