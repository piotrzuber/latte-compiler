.globl main

LStr0:
.string ""
LStr1:
.string "="
LStr2:
.string "hello */"
LStr3:
.string "/* world"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp
    pushl $10
    call fac
    popl %ebx
    pushl %eax
    call printInt
    popl %ebx
    pushl $10
    call rfac
    popl %ebx
    pushl %eax
    call printInt
    popl %ebx
    pushl $10
    call mfac
    popl %ebx
    pushl %eax
    call printInt
    popl %ebx
    pushl $10
    call ifac
    popl %ebx
    pushl %eax
    call printInt
    popl %ebx
    pushl $LStr0
    popl -4(%ebp)
    pushl $10
    popl -8(%ebp)
    pushl $1
    popl -12(%ebp)
L0:
    pushl -8(%ebp)
    pushl $0
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
    leal -12(%ebp), %eax
    pushl %eax
    pushl -12(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    decl (%eax)
    jmp L0
L2:
    pushl -12(%ebp)
    call printInt
    popl %ebx
    pushl $LStr1
    pushl $60
    call repStr
    popl %ebx
    popl %ebx
    pushl %eax
    call printString
    popl %ebx
    pushl $LStr2
    call printString
    popl %ebx
    pushl $LStr3
    call printString
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
fac:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $0
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl $1
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
L5:
    pushl -8(%ebp)
    pushl $0
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
    jmp L7
L6:
    leal -4(%ebp), %eax
    pushl %eax
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    pushl $1
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    jmp L5
L7:
    pushl -4(%ebp)
    popl %eax
    leave
    ret
rfac:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jne L13
    pushl $1
    jmp L14
L13:
    pushl $0
L14:
    popl %eax
    testl %eax, %eax
    jnz L10
    jmp L11
L10:
    pushl $1
    popl %eax
    leave
    ret
    jmp L12
L11:
    pushl 8(%ebp)
    pushl 8(%ebp)
    pushl $1
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    call rfac
    popl %ebx
    pushl %eax
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    leave
    ret
L12:
    leave
mfac:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jne L18
    pushl $1
    jmp L19
L18:
    pushl $0
L19:
    popl %eax
    testl %eax, %eax
    jnz L15
    jmp L16
L15:
    pushl $1
    popl %eax
    leave
    ret
    jmp L17
L16:
    pushl 8(%ebp)
    pushl 8(%ebp)
    pushl $1
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    call nfac
    popl %ebx
    pushl %eax
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    leave
    ret
L17:
    leave
nfac:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    je L23
    pushl $1
    jmp L24
L23:
    pushl $0
L24:
    popl %eax
    testl %eax, %eax
    jnz L20
    jmp L21
L20:
    pushl 8(%ebp)
    pushl $1
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    call mfac
    popl %ebx
    pushl %eax
    pushl 8(%ebp)
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    leave
    ret
    jmp L22
L21:
    pushl $1
    popl %eax
    leave
    ret
L22:
    leave
ifac:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $1
    pushl 8(%ebp)
    call ifac2f
    popl %ebx
    popl %ebx
    pushl %eax
    popl %eax
    leave
    ret
ifac2f:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl 12(%ebp)
    pushl 8(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jne L27
    pushl $1
    jmp L28
L27:
    pushl $0
L28:
    popl %eax
    testl %eax, %eax
    jnz L25
    jmp L26
L25:
    pushl 12(%ebp)
    popl %eax
    leave
    ret
L26:
    pushl 12(%ebp)
    pushl 8(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jle L31
    pushl $1
    jmp L32
L31:
    pushl $0
L32:
    popl %eax
    testl %eax, %eax
    jnz L29
    jmp L30
L29:
    pushl $1
    popl %eax
    leave
    ret
L30:
    pushl $0
    popl -4(%ebp)
    leal -4(%ebp), %eax
    pushl %eax
    pushl 12(%ebp)
    pushl 8(%ebp)
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl $2
    popl %ebx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ebx
    pushl %eax
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    pushl 12(%ebp)
    pushl -4(%ebp)
    call ifac2f
    popl %ebx
    popl %ebx
    pushl %eax
    pushl -4(%ebp)
    pushl $1
    popl %eax
    popl %ebx
    addl %ebx, %eax
    pushl %eax
    pushl 8(%ebp)
    call ifac2f
    popl %ebx
    popl %ebx
    pushl %eax
    popl %eax
    popl %ebx
    imul %ebx, %eax
    pushl %eax
    popl %eax
    leave
    ret
repStr:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $LStr0
    popl -4(%ebp)
    pushl $0
    popl -8(%ebp)
L33:
    pushl -8(%ebp)
    pushl 8(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jge L36
    pushl $1
    jmp L37
L36:
    pushl $0
L37:
    popl %eax
    testl %eax, %eax
    jnz L34
    jmp L35
L34:
    leal -4(%ebp), %eax
    pushl %eax
    pushl 12(%ebp)
    pushl -4(%ebp)
    call concat
    popl %ebx
    popl %ebx
    pushl %eax
    popl %eax
    popl %ebx
    movl %eax, (%ebx)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    incl (%eax)
    jmp L33
L35:
    pushl -4(%ebp)
    popl %eax
    leave
    ret
