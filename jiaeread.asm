.MODEL SMALL
.STACK 64
.DATA
    FILENAME            DB  "staff.txt", 0    ; File name
    FILE_HANDLE         DW  ?                 ; File handle
    READ_BUFFER         DB  50 DUP (?)        ; Buffer to store the read data
    BYTES_READ          DW  ?                 ; Number of bytes read
    EMPLOYEE_ID         DB  10 DUP ('$')       ; Buffer for employee ID (extra byte for $)
    PASSWORD            DB  21 DUP ('$')      ; Buffer for password (extra byte for $)
    COMMA_FOUND         DB  0                 ; Flag for comma detection
    NEWLINE             DB  0Ah, '$'          ; Newline for printing

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; Debugging output: Indicate the start of the program
    LEA DX, NEWLINE
    MOV AH, 09h
    INT 21h  ; Output newline (just to see something happens)

    ; Call the function to open the file
    CALL OPEN_FILE

    ; Debugging: check if the file was opened successfully
    LEA DX, FILENAME
    MOV AH, 09h
    INT 21h  ; Print the filename for debugging

    ; Read from the file
    MOV AH, 3Fh              ; DOS function to read from file
    MOV BX, FILE_HANDLE      ; Load file handle
    LEA DX, READ_BUFFER      ; Load buffer to store read data
    MOV CX, 50               ; Max number of bytes to read
    INT 21h                  ; Call DOS to read
    JC ERROR                 ; Jump if there is an error
    MOV BYTES_READ, AX       ; Store the number of bytes read

    ; Debugging: check if bytes were read
    LEA DX, READ_BUFFER
    MOV AH, 09h
    INT 21h  ; Print the read buffer (raw content)

    ; Call the function to process the read data
    CALL PROCESS_READ_DATA

    ; Close the file after reading
    MOV AH, 3Eh              ; DOS function to close file
    MOV BX, FILE_HANDLE      ; Load file handle
    INT 21h                  ; Call DOS to close
    JC ERROR                 ; Jump if there is an error

    ; Exit the program
    MOV AX, 4C00h
    INT 21h

MAIN ENDP

;=======================================================================

; Function to open an existing file
OPEN_FILE PROC NEAR
    MOV AH, 3Dh              ; DOS function to open an existing file
    MOV AL, 0                ; Open in read-only mode
    LEA DX, FILENAME         ; Load address of the filename
    INT 21h                  ; Call DOS
    JC ERROR                 ; Jump if there is an error
    MOV FILE_HANDLE, AX      ; Store the file handle
    RET
OPEN_FILE ENDP

;=======================================================================

; Function to process the read data
PROCESS_READ_DATA PROC NEAR
    LEA SI, READ_BUFFER      ; Start reading from the buffer
    LEA DI, EMPLOYEE_ID      ; Start copying to EMPLOYEE_ID
    MOV CX, 50               ; Set the loop count to max bytes read

    FIND_COMMA:
        LODSB                ; Load byte from buffer into AL
        CMP AL, ','          ; Check if it's a comma
        JE COMMA_DETECTED    ; Jump if a comma is found
        CMP AL, 0Ah          ; Check for end of line
        JE DONE_PROCESSING   ; Done if end of line
        STOSB                ; Store byte into EMPLOYEE_ID
        LOOP FIND_COMMA      ; Continue until comma or end of buffer

    COMMA_DETECTED:
        MOV COMMA_FOUND, 1   ; Set flag that comma was found
        MOV BYTE PTR [DI], '$' ; Add '$' terminator to EMPLOYEE_ID
        LEA DI, PASSWORD     ; Switch to storing in PASSWORD
        JMP FIND_PASSWORD    ; Continue processing

    FIND_PASSWORD:
        LODSB                ; Load byte from buffer into AL
        CMP AL, 0Ah          ; Check if it's end of line (newline)
        JE DONE_PROCESSING   ; Done if newline
        STOSB                ; Store byte into PASSWORD
        LOOP FIND_PASSWORD    ; Continue copying to password

    DONE_PROCESSING:
        MOV BYTE PTR [DI], '$' ; Add '$' terminator to PASSWORD

        ; Now print EMPLOYEE_ID and PASSWORD using DOS interrupt 09h
        ; Debugging: Check if employee ID and password are processed correctly

        LEA DX, EMPLOYEE_ID
        MOV AH, 09h          ; Print string function
        INT 21h              ; Print employee ID

        LEA DX, NEWLINE
        MOV AH, 09h          ; Print newline
        INT 21h

        LEA DX, PASSWORD
        MOV AH, 09h          ; Print string function
        INT 21h              ; Print password

        RET
PROCESS_READ_DATA ENDP

;=======================================================================

ERROR:
    MOV AH, 4Ch              ; Exit the program with an error code
    MOV AL, 01h              ; Error code 1
    INT 21h

END MAIN