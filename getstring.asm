.MODEL SMALL
.STACK 64
.DATA
    STAFF_ID DB 8 DUP (0)   ; Buffer to store up to 7 characters plus a terminator
    NEWLINE DB 0Dh, 0Ah, '$' ; Newline for output

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; Get staff ID from user input
    CALL GET_STAFF_ID

    ; Print the staff ID
    CALL PRINT_STAFF_ID

    ; Exit the program
    MOV AX, 4C00h
    INT 21h
MAIN ENDP

;=======================================================================

GET_STAFF_ID PROC NEAR
    MOV CX, 7                ; Set the loop counter for 7 characters
    LEA DI, STAFF_ID         ; Load the address of STAFF_ID into DI

GET_STAFF_ID_LOOP:
    MOV AH, 01H              ; Function to read character from standard input
    INT 21H                  ; Call DOS interrupt
    CMP AL, 0Dh              ; Check if Enter key is pressed (Carriage Return)
    JE DONE_INPUT            ; If Enter key, jump to done input
    MOV [DI], AL             ; Store the character in STAFF_ID
    INC DI                   ; Move to the next position in STAFF_ID
    LOOP GET_STAFF_ID_DONE_INPUT   ; Repeat until CX is 0

GET_STAFF_ID_DONE_INPUT:
    MOV BYTE PTR [DI], '$'   ; Set end of string

    RET
GET_STAFF_ID ENDP

;=======================================================================

PRINT_STAFF_ID PROC NEAR
    ; Print the stored staff ID
    LEA DX, STAFF_ID         ; Load address of STAFF_ID into DX
    MOV AH, 09H              ; Function to print string
    INT 21h                  ; Call DOS interrupt

    ; Print a newline
    LEA DX, NEWLINE
    MOV AH, 09H              ; Function to print string
    INT 21h                  ; Call DOS interrupt

    RET
PRINT_STAFF_ID ENDP

;=======================================================================

END MAIN
