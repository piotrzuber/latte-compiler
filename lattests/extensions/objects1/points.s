.globl main


.Point2_vtable: .int Point2$move,Point2$getX,Point2$getY
.Point3_vtable: .int Point2$move,Point2$getX,Point2$getY,Point3$moveZ,Point3$getZ
.Point4_vtable: .int Point2$move,Point2$getX,Point2$getY,Point3$moveZ,Point3$getZ,Point4$moveW,Point4$getW
Point2$move:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 16(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    leal 16(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 4(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    pushl 12(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal 16(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    leal 16(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 8(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
Point2$getX:
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
Point2$getY:
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
Point3$moveZ:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 12(%ecx), %eax
    pushl %eax
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 12(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
Point3$getZ:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 12(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    popl %eax
    leave
    ret
Point4$moveW:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 16(%ecx), %eax
    pushl %eax
    leal 12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 16(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    pushl 8(%ebp)
    popl %eax
    popl %ecx
    addl %ecx, %eax
    pushl %eax
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leave
    ret
Point4$getW:
    pushl %ebp
    movl %esp, %ebp
    subl $0, %esp
    leal 8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    leal 16(%ecx), %eax
    pushl %eax
    popl %eax
    pushl (%eax)
    popl %eax
    leave
    ret
main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp
    pushl $4
    pushl $16
    call calloc
    popl %ecx
    popl %ecx
    movl $.Point3_vtable, (%eax)
    pushl %eax
    popl -4(%ebp)
    pushl $4
    pushl $16
    call calloc
    popl %ecx
    popl %ecx
    movl $.Point3_vtable, (%eax)
    pushl %eax
    popl -8(%ebp)
    pushl $4
    pushl $20
    call calloc
    popl %ecx
    popl %ecx
    movl $.Point4_vtable, (%eax)
    pushl %eax
    popl -12(%ebp)
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $2
    pushl $4
    call *0(%edx)
    addl $8, %esp
    popl %ecx
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $7
    call *12(%edx)
    addl $4, %esp
    popl %ecx
    leal -4(%ebp), %eax
    pushl %eax
    pushl -8(%ebp)
    popl %eax
    popl %ecx
    movl %eax, (%ecx)
    leal -4(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $3
    pushl $5
    call *0(%edx)
    addl $8, %esp
    popl %ecx
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $1
    pushl $3
    call *0(%edx)
    addl $8, %esp
    popl %ecx
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $6
    call *12(%edx)
    addl $4, %esp
    popl %ecx
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    pushl $2
    call *20(%edx)
    addl $4, %esp
    popl %ecx
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
    call printInt
    addl $4, %esp
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
    call printInt
    addl $4, %esp
    leal -8(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *16(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    call printInt
    addl $4, %esp
    leal -12(%ebp), %eax
    pushl %eax
    popl %eax
    movl (%eax), %ecx
    movl (%ecx), %edx
    pushl (%eax)
    call *24(%edx)
    addl $0, %esp
    pushl %eax
    popl %ecx
    popl %ecx
    pushl %eax
    call printInt
    addl $4, %esp
    pushl $0
    popl %eax
    leave
    ret
