.model small
.stack 100h

.data
    number DW 10000            ; Original number
    intPart DW 0               ; To store the integer part
    fracPart DW 0           ; To store the fractional part as string
    output DB '000.00$', 0     ; Buffer for output (with $ as string terminator)
    

.code
main:
    ; Initialize the data for division
    mov ax, number              ; Load the number into AX
    mov bx, 100                 ; Set divisor to 100
    xor dx, dx                  ; Clear DX for division
    div bx                      ; AX = AX / BX, result in AX, remainder in DX

    mov intPart, ax             ; Store integer part in intPart
    mov fracPart, dx            ; Store decimel part in fracPart
    ; DX now contains the fractional part (remainder)
    
    ; Convert integer part to string
    call ConvertToString
    
    ; Display the result
    lea dx, output              ; Load address of output buffer
    call PRINT                  ; Call the PRINT procedure

    mov ax, 4C00h               ; Terminate program
    int 21h

; Subroutine to convert integer to string
ConvertToString PROC
    mov ax, intPart             ; Load integer part
    mov cx, 0                   ; Counter for digits

convertLoop1:
    xor dx, dx                  ; Clear DX before division
    mov bx, 10
    div bx                      ; AX = AX / BX, remainder in DX
    push dx                     ; Store remainder (digit) on stack
    inc cx                      ; Increment digit counter
    test ax, ax                 ; Check if AX is zero
    jnz convertLoop1             ; Repeat if not zero

    ; Now pop digits off stack and place in output buffer
    mov di, 0                   ; DI points to the output string
popLoop1:
    pop dx                      ; Get the digit from stack
    add dl, '0'                 ; Convert to ASCII, '0' is 48, 48+ dl = the number in dl as a char
    mov output[di], dl          ; Store in output
    inc di                      ; Move to next position
    loop popLoop1                ; Repeat for all digits

    ; Insert decimal point
    mov output[di], '.'        ; Place the decimal point
    inc di                     ; Move to next position

    mov ax, fracPart
    mov cx, 0

convertLoop2:
    xor dx, dx                  ; Clear DX before division
    mov bx, 10
    div bx                      ; AX = AX / BX, remainder in DX
    push dx                     ; Store remainder (digit) on stack
    inc cx                      ; Increment digit counter
    test ax, ax                 ; Check if AX is zero
    jnz convertLoop2            ; Repeat if not zero

    ; Now pop digits off stack and place in output buffer
    mov di, 0                   ; DI points to the output string
popLoop2:
    pop dx                      ; Get the digit from stack
    add dl, '0'                 ; Convert to ASCII, '0' is 48, 48+ dl = the number in dl as a char
    mov output[di], dl          ; Store in output
    inc di                      ; Move to next position
    loop popLoop2               ; Repeat for all digits

    mov output[di], '$'        ; Terminate the string with $
    ret
ConvertToString ENDP

; PRINT Procedure to display a string
PRINT PROC NEAR
    MOV AH, 09H                ; DOS function to display a string
    INT 21H                    ; Call DOS interrupt
    RET                         ; Return from procedure
PRINT ENDP

end main