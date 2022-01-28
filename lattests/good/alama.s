.globl main

LStr0:
.string "alamakota"
LStr1:
.string "ala"
LStr2:
.string "ma"
LStr3:
.string "kota"
LStr4:
.string "OK"
LStr5:
.string "ERROR"

main:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    pushl $LStr0
    popl -4(%ebp)
    pushl -4(%ebp)
    pushl $LStr3
    pushl $LStr2
    pushl $LStr1
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    call concat
    popl %ecx
    popl %ecx
    pushl %eax
    popl %eax
    testl %eax, %eax
    jnz L0
    jmp L1
L0:
    pushl $LStr4
    call printString
    addl $4, %esp
    jmp L2
L1:
    pushl $LStr5
    call printString
    addl $4, %esp
L2:
    pushl $0
    popl %eax
    leave
    ret
