.globl main

LStr0:
.string "apa"
LStr1:
.string "true"
LStr2:
.string "false"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $4
    popl -4(%ebp)
    pushl $3
    pushl -4(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jg L4
    pushl $1
    jmp L5
L4:
    pushl $0
L5:
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L3
L3:
    pushl $4
    pushl $2
    popl %eax
    cmpl %eax, 0(%esp)
    je L7
    pushl $1
    jmp L8
L7:
    pushl $0
L8:
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L6
L6:
    pushl $1
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L0
L1:
    pushl $1
    call printBool
    popl %ebx
    jmp L2
L0:
    pushl $LStr0
    call printString
    popl %ebx
L2:
    pushl $1
    pushl $1
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
    jmp L12
L12:
    pushl $1
    call dontCallMe
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L10
    jmp L9
L10:
    pushl $1
    jmp L11
L9:
    pushl $0
L11:
    call printBool
    popl %ebx
    pushl $4
    pushl $5
    popl %eax
    neg %eax
    pushl %eax
    popl %eax
    cmpl %eax, 0(%esp)
    jge L19
    pushl $1
    jmp L20
L19:
    pushl $0
L20:
    popl %eax
    testl %eax, %eax
    jnz L15
    jmp L18
L18:
    pushl $2
    call dontCallMe
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L15
    jmp L16
L16:
    pushl $1
    jmp L17
L15:
    pushl $0
L17:
    call printBool
    popl %ebx
    pushl $4
    pushl -4(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jne L25
    pushl $1
    jmp L26
L25:
    pushl $0
L26:
    popl %eax
    testl %eax, %eax
    jnz L21
    jmp L24
L24:
    pushl $1
    pushl $0
    popl %eax
    testl %eax, %eax
    jnz L29
    jmp L28
L29:
    pushl $1
    jmp L30
L28:
    pushl $0
L30:
    popl %eax
    cmpl %eax, 0(%esp)
    jne L31
    pushl $1
    jmp L32
L31:
    pushl $0
L32:
    popl %eax
    testl %eax, %eax
    jnz L22
    jmp L27
L27:
    pushl $1
    popl %eax
    testl %eax, %eax
    jnz L22
    jmp L21
L22:
    pushl $1
    jmp L23
L21:
    pushl $0
L23:
    call printBool
    popl %ebx
    pushl $0
    pushl $0
    call implies
    popl %ebx
    popl %ebx
    pushl %eax
    call printBool
    popl %ebx
    pushl $0
    pushl $1
    call implies
    popl %ebx
    popl %ebx
    pushl %eax
    call printBool
    popl %ebx
    pushl $1
    pushl $0
    call implies
    popl %ebx
    popl %ebx
    pushl %eax
    call printBool
    popl %ebx
    pushl $1
    pushl $1
    call implies
    popl %ebx
    popl %ebx
    pushl %eax
    call printBool
    popl %ebx
    pushl $0
    popl %eax
    leave
    ret
dontCallMe:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    call printInt
    popl %ebx
    pushl $1
    popl %eax
    leave
    ret
printBool:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    popl %eax
    testl %eax, %eax
    jnz L34
    jmp L33
L34:
    pushl $LStr1
    call printString
    popl %ebx
    jmp L35
L33:
    pushl $LStr2
    call printString
    popl %ebx
L35:
    leave
    ret
implies:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 12(%ebp)
    popl %eax
    testl %eax, %eax
    jnz L37
    jmp L39
L39:
    pushl 12(%ebp)
    pushl 8(%ebp)
    popl %eax
    cmpl %eax, 0(%esp)
    jne L40
    pushl $1
    jmp L41
L40:
    pushl $0
L41:
    popl %eax
    testl %eax, %eax
    jnz L37
    jmp L36
L37:
    pushl $1
    jmp L38
L36:
    pushl $0
L38:
    popl %eax
    leave
    ret
