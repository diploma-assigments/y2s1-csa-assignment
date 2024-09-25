.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    DB_TEMP                 DB      "TestUser", 0 ; Test username
    DB_TEMP_PASSWORD        DB      "TestPass", 0 ; Test password
    NEWLINE                 DB      0DH, 0AH, '$'  ; Newline character (CR + LF)
    
    STAFF_FILE              DB      "staff.txt", 0 ; Filename for staff data
    FILE_HANDLE             DW      ?              ; File handle

    successMsg              DB      "Data written successfully.$"
    errorMsg                DB      "Error writing to file.$"

.CODE
MAIN PROC FAR
    MOV     AX, @DATA                  ; load data segment address to DS register
    MOV     DS, AX

    ; Test file write
    CALL    WRITE_TO_FILE

    ; End program
    MOV     AX, 4C00H                    ; request for program exit
    INT     21H
MAIN ENDP

;==========================================================================================================
; Write to file (Function 40h)
WRITE_TO_FILE PROC NEAR
    ; Open the file for appending
    MOV AH, 3Dh                        ; function 3Dh: open file
    MOV AL, 2                          ; mode: open file for writing
    LEA DX, STAFF_FILE                 ; filename
    INT 21h                            ; call DOS interrupt
    JC error                           ; jump if error (carry flag set)
    
    MOV FILE_HANDLE, AX                ; save file handle
    
    ; Seek to the end of the file for appending
    MOV AH, 42h                        ; function 42h: seek
    MOV AL, 2                          ; seek to end of file
    XOR CX, CX                         ; offset high
    XOR DX, DX                         ; offset low
    INT 21h                            ; call DOS interrupt
    JC error                           ; jump if error (carry flag set)

    ; Write username to file
    MOV AH, 40h                        ; function 40h: write to file
    MOV BX, FILE_HANDLE                ; file handle
    LEA DX, DB_TEMP                    ; address of the username buffer
    MOV CX, 20                         ; number of bytes to write (username)
    INT 21h                            ; call DOS interrupt
    JC error                           ; jump if error (carry flag set)

    ; Write password to file
    MOV AH, 40h                        ; function 40h: write to file
    MOV BX, FILE_HANDLE                ; file handle
    LEA DX, DB_TEMP_PASSWORD           ; address of the password buffer
    MOV CX, 20                         ; number of bytes to write (password)
    INT 21h                            ; call DOS interrupt
    JC error                           ; jump if error (carry flag set)

    ; Write newline to file (optional for readability)
    MOV AH, 40h                        ; function 40h: write to file
    MOV BX, FILE_HANDLE                ; file handle
    LEA DX, NEWLINE                    ; address of newline character
    MOV CX, 2                          ; number of bytes for newline (CR LF)
    INT 21h                            ; call DOS interrupt
    JC error                           ; jump if error (carry flag set)

    ; Close the file
    MOV AH, 3Eh                        ; function 3Eh: close file
    MOV BX, FILE_HANDLE                ; file handle
    INT 21h                            ; call DOS interrupt

    ; Indicate success
    LEA DX, successMsg                 ; Load success message
    CALL PRINT
    RET

error:
    LEA DX, errorMsg                   ; Load error message
    CALL PRINT
    RET
WRITE_TO_FILE ENDP

;==========================================================================================================
; Procedure to print string (assumes DX holds address of string)
PRINT PROC NEAR
    MOV     AH, 09H                      ; function 09H: Print string to stdout
    INT     21H
    RET
PRINT ENDP

END MAIN