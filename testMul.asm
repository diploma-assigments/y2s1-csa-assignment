.model small
.stack 100h

.data
    try         DW 12345              ; Original value
    fracString  DB "000000", '$'       ; Buffer for result string
    TenThousand DW 10000
    Thousand    DW 1000
    Hundred     DW 100                  ; Constant for division
    Ten         DW 10                   ; Constant for division

.code
main proc far                           ; Declare main as a far procedure

    mov ax , @data  
    mov ds , ax
    
    call DOUBLE_VALUE

    lea dx, fracString                  ; Load address of output buffer
    call PRINT                          ; Call the PRINT procedure

Exit:
    mov ax, 4C00h                       ; Terminate program
    int 21h

main endp                               ; End of far procedure

DOUBLE_VALUE PROC
    mov si, 0                           ; Use SI as an index for fracString
    mov ax, try                         ; Load 'try' into AX
    xor dx, dx                          ; Clear DX for division

    cmp ax, TenThousand                 ; Compare 'try' with TenThousand
    jge  TT                              ; If equal, jump to TT
    cmp ax, Thousand                    ; Compare 'try' with Thousand
    jge  T                               ; If equal to Thousand, jump to T
    cmp ax, Hundred                     ; Compare 'try' with Hundred
    jl  Exit                            ; If smaller than Hundred, jump to Exit
    jmp H                               ; If greater or equal to Hundred, jump to H

TT: 

    div TenThousand                     ; Divide by 10000
    mov fracString[si], al             ; Store quotient in fracString
    add fracString[si], 30h             ; Convert to ASCII
    inc si                              ; Increment index
    mov ax, dx                          ; Move remainder into AX
    xor dx, dx                          ; Clear DX
    jmp T                               ; Proceed to Thousand

T:  
    div Thousand                        ; Divide by 1000
    mov fracString[si], al             ; Store quotient
    add fracString[si], 30h             ; Convert to ASCII
    inc si                              ; Increment index
    mov ax, dx                          ; Move remainder into AX
    xor dx, dx                          ; Clear DX
    jmp H

H:  
    div Hundred                         ; Divide by 100
    mov fracString[si], al             ; Store quotient
    add fracString[si], 30h             ; Convert to ASCII
    inc si
    mov ax, dx                          ; Move remainder into AX

    xor dx, dx                          ; Clear DX
    mov fracString[si], ','             ; Insert comma
    div Ten                             ; Divide by 10
    inc si
    mov fracString[si], al              ; Store first decimal place
    add fracString[si], 30h             ; Convert to ASCII
    mov ax,dx
    
    xor dx, dx
    inc si
    mov fracString[si], al              ; Store second decimal place
    add fracString[si], 30h             ; Convert to ASCII
    RET
DOUBLE_VALUE ENDP

; PRINT Procedure to display a string
PRINT PROC
    MOV AH, 09H                         ; DOS function to display a string
    INT 21H                             ; Call DOS interrupt
    RET                                 ; Return from procedure
PRINT ENDP

end main                                ; Mark the end of the program