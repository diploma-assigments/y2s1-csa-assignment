.model small
.stack 100h

.data
    try DB 127                 ; Original value as a byte
    intPart DB 0               ; To store the integer part (as byte)
    fracPart DB 0              ; To store the fractional part (not used here)
    fracString DB 5 DUP(0), 0  ; Buffer for output string, initialized with 0

    Hundred DB 100             ; Constant for division
    Ten DB 10                  ; Constant for division

.code
main proc far

    mov ax , @data  
    mov ds , ax
    
    
    xor dx, dx                 ; Clear DX for division
    mov al, try                ; Load the value from 'try' into AL
    div Hundred                 ; Divide AL by 100
    mov fracString[2], al      ; Store the result in fracString[2]
    mov al, ah
    mov ah, 0                 ; Clear AH to get the integer part
    div Ten
    mov fracString[3], ','     ; Add a comma
    mov fracString[4], ah      ; Store the remaining part (should be 0)
    mov fracString[5], al     ; Add a zero for the fractional part

    ; Display the result
    lea dx, fracString         ; Load address of output buffer
    call PRINT                 ; Call the PRINT procedure

    mov ax, 4C00h              ; Terminate program
    int 21h

    main    endp

; PRINT Procedure to display a string
PRINT PROC NEAR
    MOV AH, 09H                ; DOS function to display a string
    INT 21H                    ; Call DOS interrupt
    RET                         ; Return from procedure
PRINT ENDP

end main