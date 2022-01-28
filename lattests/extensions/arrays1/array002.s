.globl main


doubleArray:
    pushl %ebp
    movl %esp, %ebp
    subl $20, %esp
    pushl $4
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    call calloc
    popl %edx
    popl %ecx
    pushl %edx
    pushl %eax
    popl -8(%ebp)
    popl -4(%ebp)
    pushl $0
    popl -12(%ebp)
    pushl $0
    popl -16(%ebp)
L0:
    pushl -16(%ebp)
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L3
    pushl $1
    jmp L4
L3:
    pushl $0
L4:
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L2
L1:
    leal 8(%ebp), %eax
    pushl %eax
    pushl -16(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl -20(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    pushl -12(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    pushl $2
    pushl -20(%ebp)
    popl %eax
    popl %ecx
    imul %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    leal -16(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L0
L2:
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %edx
    leave
    ret
shiftLeft:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    leal 8(%ebp), %eax
    pushl %eax
    pushl $0
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
L5:
    pushl -8(%ebp)
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    pushl $1
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    popl %eax
    cmpl %eax, 0(%esp)
    jge L8
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
    leal 8(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    leal 8(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    pushl $1
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L5
L7:
    leal 8(%ebp), %eax
    pushl %eax
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    pushl $1
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    pushl -4(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
scalProd:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $0
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
L10:
    pushl -8(%ebp)
    leal 16(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L13
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
    pushl -4(%ebp)
    leal 16(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    leal 8(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl %eax
    popl %ecx
    imul %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L10
L12:
    pushl -4(%ebp)
    popl %eax
    leave
    ret
main:
    pushl %ebp
    movl %esp, %ebp
    subl $36, %esp
    pushl $4
    pushl $5
    call calloc
    popl %edx
    popl %ecx
    pushl %edx
    pushl %eax
    popl -8(%ebp)
    popl -4(%ebp)
    pushl $0
    popl -12(%ebp)
L15:
    pushl -12(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L18
    pushl $1
    jmp L19
L18:
    pushl $0
L19:
    popl %eax
    testl %eax, %eax
    jnz L16
    jmp L17
L16:
    leal -8(%ebp), %eax
    pushl %eax
    pushl -12(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    pushl -12(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L15
L17:
    pushl -4(%ebp)
    pushl -8(%ebp)
    call shiftLeft
    addl $8, %esp
    pushl -4(%ebp)
    pushl -8(%ebp)
    call doubleArray
    addl $8, %esp
    pushl %edx
    pushl %eax
    popl -20(%ebp)
    popl -16(%ebp)
    pushl $0
    popl -24(%ebp)
L20:
    pushl -24(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L23
    pushl $1
    jmp L24
L23:
    pushl $0
L24:
    popl %eax
    testl %eax, %eax
    jnz L21
    jmp L22
L21:
    leal -8(%ebp), %eax
    pushl %eax
    pushl -24(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl -28(%ebp)
    pushl -28(%ebp)
    call printInt
    addl $4, %esp
    leal -24(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L20
L22:
    pushl $0
    popl -24(%ebp)
L25:
    pushl -24(%ebp)
    leal -20(%ebp), %eax
    pushl %eax
    popl %eax
    pushl 4(%eax)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L28
    pushl $1
    jmp L29
L28:
    pushl $0
L29:
    popl %eax
    testl %eax, %eax
    jnz L26
    jmp L27
L26:
    leal -20(%ebp), %eax
    pushl %eax
    pushl -24(%ebp)
    popl %eax
    popl %edx
    movl (%edx), %ecx
    leal (%ecx, %eax, 4), %edx
    pushl %edx
    popl %eax
    pushl (%eax)
    popl -28(%ebp)
    pushl -28(%ebp)
    call printInt
    addl $4, %esp
    leal -24(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L25
L27:
    pushl -4(%ebp)
    pushl -8(%ebp)
    pushl -16(%ebp)
    pushl -20(%ebp)
    call scalProd
    addl $16, %esp
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
