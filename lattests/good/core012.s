.globl main

LStr0:
.string "string"
LStr1:
.string " "
LStr2:
.string "concatenation"
LStr3:
.string "true"
LStr4:
.string "false"

main:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    pushl $56
    popl -4(%ebp)
    pushl $23
    popl %eax
    neg %eax
    pushl %eax
    popl -8(%ebp)
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    call printInt
    addl $4, %esp
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    call printInt
    addl $4, %esp
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    imul %ecx, %eax
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $45
    pushl $2
    popl %ecx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ecx
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $78
    pushl $3
    popl %ecx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ecx
    pushl %edx
    call printInt
    addl $4, %esp
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    subl %eax, %ecx
    pushl %ecx
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    cmpl %eax, 0(%esp)
    jle L0
    pushl $1
    jmp L1
L0:
    pushl $0
L1:
    call printBool
    addl $4, %esp
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %ecx
    popl %eax
    movl %eax, %edx
    sar $31, %edx
    idiv %ecx
    pushl %eax
    pushl -4(%ebp)
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    imul %ecx, %eax
    pushl %eax
    popl %eax
    cmpl %eax, 0(%esp)
    jg L2
    pushl $1
    jmp L3
L2:
    pushl $0
L3:
    call printBool
    addl $4, %esp
    pushl $LStr2
    pushl $LStr1
    pushl $LStr0
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    call printString
    addl $4, %esp
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
    jnz L4
    jmp L5
L4:
    pushl $LStr3
    call printString
    addl $4, %esp
    leave
    ret
    jmp L6
L5:
    pushl $LStr4
    call printString
    addl $4, %esp
    leave
    ret
L6:
    leave
    ret
