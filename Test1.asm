.model small
.stack 64
.data

;ah 10 input array
array db 10,?,8 dup ("$")
nl db 10,13,'$'

.code
main proc far
mov ax,@data
mov ds,ax

mov ah,10
lea dx,array
int 21h

mov ah,9
lea dx,nl
int 21h

mov ah,9
lea dx,array+2
int 21h





mov ah, 4ch
int 21h
main endp
end main