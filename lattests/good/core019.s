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
    popl %ebx
    pushl -4(%ebp)
    call printInt
    popl %ebx
L1:
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
    jnz L0
    jmp L2
L0:
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    decl (%eax)
    pushl -4(%ebp)
    call printInt
    popl %ebx
    pushl -4(%ebp)
    pushl $7
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    popl -8(%ebp)
    pushl -8(%ebp)
    call printInt
    popl %ebx
    jmp L1
L2:
    pushl -4(%ebp)
    call printInt
    popl %ebx
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
    jnz L6
    jmp L5
L6:
    pushl $4
    popl -8(%ebp)
    pushl -8(%ebp)
    call printInt
    popl %ebx
    jmp L7
L5:
    pushl $LStr0
    call printString
    popl %ebx
L7:
    pushl -4(%ebp)
    call printInt
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
