.globl main



main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    pushl $50
    call fromTo
    addl $8, %esp
    pushl %eax
    call length
    addl $4, %esp
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $1
    pushl $100
    call fromTo
    addl $8, %esp
    pushl %eax
    call length2
    addl $4, %esp
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
head:
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
cons:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $0
    popl -4(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl $4
    pushl $12
    call calloc
    popl %ecx
    popl %ecx
    movl $0, (%eax)
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    pushl 12(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    pushl -4(%ebp)
    popl %eax
    leave
    ret
length:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jne L3
    pushl $1
    jmp L4
L3:
    pushl $0
L4:
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $0
    popl %eax
    leave
    ret
    jmp L2
L1:
    pushl $1
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    call length
    addl $4, %esp
    pushl %eax
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    leave
    ret
L2:
    leave
    ret
fromTo:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 12(%ebp)
    pushl 8(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jle L8
    pushl $1
    jmp L9
L8:
    pushl $0
L9:
    popl %eax
    testl %eax, %eax
    jnz L5
    jmp L6
L5:
    pushl $0
    popl %eax
    leave
    ret
    jmp L7
L6:
    pushl 12(%ebp)
    pushl 12(%ebp)
    pushl $1
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    pushl 8(%ebp)
    call fromTo
    addl $8, %esp
    pushl %eax
    call cons
    addl $8, %esp
    pushl %eax
    popl %eax
    leave
    ret
L7:
    leave
    ret
length2:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $0
    popl -4(%ebp)
L10:
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    je L13
    pushl $1
    jmp L14
L13:
    pushl $0
L14:
    popl %eax
    testl %eax, %eax
    jnz L11
    jmp L12
L11:
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    leal 8(%ebp), %eax
    pushl %eax
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    jmp L10
L12:
    pushl -4(%ebp)
    popl %eax
    leave
    ret
