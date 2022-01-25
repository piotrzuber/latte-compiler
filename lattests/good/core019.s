.globl main

LStr0:
.string "foo"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $16, %esp
    pushl $78
    popl -4(%ebp)
    pushl $1
    popl -8(%ebp)
    pushl -8(%ebp)
    call printInt
    addl $4, %esp
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
L0:
    pushl -4(%ebp)
    pushl $76
    popl %eax
    cmpl %eax, 0(%esp)
    jle L3
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
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    decl (%eax)
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
    pushl -4(%ebp)
    pushl $7
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl -8(%ebp)
    pushl -8(%ebp)
    call printInt
    addl $4, %esp
    jmp L0
L2:
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
    pushl -4(%ebp)
    pushl $4
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
    pushl $4
    popl -8(%ebp)
    pushl -8(%ebp)
    call printInt
    addl $4, %esp
    jmp L7
L6:
    pushl $LStr0
    call printString
    addl $4, %esp
L7:
    pushl -4(%ebp)
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
