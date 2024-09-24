.model small
.stack 100h

.data
    myString DB 'Hello, World!', '$'   ; String with $ terminator
    Strlength DW 0                        ; Variable to store string length

.code
main:
    mov ax, @data
    mov ds, ax               ; Initialize data segment

    lea si, myString          ; Load the address of the string into SI
    call StrLen               ; Call the StrLen subroutine

    mov Strlength, cx
    add Strlength, 30h

    lea dx, Strlength          ; Load address of output buffer
    call PRINT                 ; Call the PRINT procedure

    mov ax, 4C00h                  ; Terminate program
    int 21h

; Subroutine to calculate string length (terminated by $)
StrLen PROC
    xor cx, cx                ; Clear CX to use it as a counter

count_loop:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    cmp al, '$'               ; Check if it's the string terminator
    je done                   ; If yes, exit the loop
    inc cx                    ; Increment counter for each character
    jmp count_loop            ; Repeat until we hit the terminator

done:
    add StrLen, cx
    add StrLen, 30h
    ret                       ; Return to caller, length is in CX
StrLen ENDP

PRINT PROC NEAR
    MOV     AH, 09H           ; function 09H: Print string to stdout
    INT     21H
    RET
PRINT ENDP

end main