.globl main

LStr0:
.string "&&"
LStr1:
.string "||"
LStr2:
.string "!"
LStr3:
.string "false"
LStr4:
.string "true"
main:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl $LStr0
    call printString
    popl %ebx
    pushl $1
    popl %eax
    neg %eax
    pushl %eax
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L3
    jmp L0
L3:
    pushl $0
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L1
    jmp L0
L1:
    pushl $1
    jmp L2
L0:
    pushl $0
L2:
    call printBool
    popl %ebx
    pushl $2
    popl %eax
    neg %eax
    pushl %eax
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L7
    jmp L4
L7:
    pushl $1
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L5
    jmp L4
L5:
    pushl $1
    jmp L6
L4:
    pushl $0
L6:
    call printBool
    popl %ebx
    pushl $3
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L11
    jmp L8
L11:
    pushl $5
    popl %eax
    neg %eax
    pushl %eax
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L9
    jmp L8
L9:
    pushl $1
    jmp L10
L8:
    pushl $0
L10:
    call printBool
    popl %ebx
    pushl $234234
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L15
    jmp L12
L15:
    pushl $21321
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L13
    jmp L12
L13:
    pushl $1
    jmp L14
L12:
    pushl $0
L14:
    call printBool
    popl %ebx
    pushl $LStr1
    call printString
    popl %ebx
    pushl $1
    popl %eax
    neg %eax
    pushl %eax
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L17
    jmp L19
L19:
    pushl $0
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L17
    jmp L16
L17:
    pushl $1
    jmp L18
L16:
    pushl $0
L18:
    call printBool
    popl %ebx
    pushl $2
    popl %eax
    neg %eax
    pushl %eax
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L21
    jmp L23
L23:
    pushl $1
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L21
    jmp L20
L21:
    pushl $1
    jmp L22
L20:
    pushl $0
L22:
    call printBool
    popl %ebx
    pushl $3
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L25
    jmp L27
L27:
    pushl $5
    popl %eax
    neg %eax
    pushl %eax
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L25
    jmp L24
L25:
    pushl $1
    jmp L26
L24:
    pushl $0
L26:
    call printBool
    popl %ebx
    pushl $234234
    call test
    popl %ebx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L29
    jmp L31
L31:
    pushl $21321
    call test
    popl %ebx
    pushl %eax
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
    call printBool
    popl %ebx
    pushl $LStr2
    call printString
    popl %ebx
    pushl $1
    call printBool
    popl %ebx
    pushl $0
    call printBool
    popl %ebx
    pushl $0
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
    jnz L32
    jmp L33
L33:
    pushl $LStr3
    call printString
    popl %ebx
    jmp L34
L32:
    pushl $LStr4
    call printString
    popl %ebx
L34:
    leave
    ret
test:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    pushl 8(%ebp)
    call printInt
    popl %ebx
    pushl 8(%ebp)
    pushl $0
    popl %eax
    cmpl %eax, 0(%esp)
    jle L35
    pushl $1
    jmp L36
L35:
    pushl $0
L36:
    popl %eax
    leave
    ret
