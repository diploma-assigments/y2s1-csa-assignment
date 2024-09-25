.MODEL SMALL
.STACK 100H

.DATA
    CONTAIN_STRING DB 20 DUP('$')       ; Declare storage for the string input
    PROMPT DB 'Enter a string (max 20 chars): $', 0
    OUTPUT_MSG DB 'You entered: $', 0

.CODE
MAIN PROC FAR
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ; Clear the screen
    CALL CLS

    ; Prompt the user for input
    LEA DX, PROMPT
    CALL PRINT

    ; Get the string input
    LEA BX, CONTAIN_STRING          ; BX points to the destination for the string
    CALL GET_STRING

    ; Print the output message
    LEA DX, OUTPUT_MSG
    CALL PRINT

    ; Print the entered string
    LEA DX, CONTAIN_STRING
    CALL PRINT

    ; Wait for a key press before exiting
    MOV AH, 00H
    INT 21H

    ; Exit the program
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

;==========================================================================================================
; Procedure to get a string input from the user
GET_STRING PROC NEAR
    MOV CX, 20                       ; Max length
    MOV DI, BX                       ; DI points to the destination (string)
    MOV SI, 0                        ; Initialize a counter for the string length

GET_STRING_LOOP:
    CALL GET_INPUT                   ; Get a single character
    CMP AL, 08H                      ; Check if Backspace key is pressed
    JE HANDLE_BACKSPACE              ; If yes, handle backspace

    CMP AL, 0DH                      ; Check if Enter key (carriage return) is pressed
    JE END_GET_STRING                ; If yes, end the input loop

    ; Store character if within max length
    CMP SI, 20                       ; Compare length counter with max length
    JAE END_GET_STRING               ; If SI >= 20, jump to end

    STOSB                             ; Store character in the destination
    INC SI                            ; Increment the string length counter
    JMP GET_STRING_LOOP               ; Loop until the max length is reached

HANDLE_BACKSPACE:
    CMP SI, 0                        ; Check if the string is empty
    JE GET_STRING_LOOP               ; If yes, do nothing

    DEC SI                           ; Decrement the string length counter
    MOV AL, 20H                     ; ASCII code for space
    STOSB                             ; Overwrite the previous character with a space
    MOV AL, 08H                     ; ASCII code for backspace
    CALL PRINT_CHAR                   ; Print the backspace character
    JMP GET_STRING_LOOP              ; Loop back to get the next character

END_GET_STRING:
    ; Add the '$' terminator only if something was entered
    CMP SI, 0                        ; Check if anything was entered
    JE NO_INPUT                     ; If no input, skip adding '$'

    MOV BYTE PTR [DI], '$'          ; Null terminate the string
    RET

NO_INPUT:
    MOV BYTE PTR [DI], '$'          ; Ensure a terminator even if no input was entered
    RET
GET_STRING ENDP

;==========================================================================================================
; Procedure to print a string (assumes DX holds the address of the string)
PRINT PROC NEAR
    MOV AH, 09H                    ; Function 09H: Print string to stdout
    INT 21H
    RET
PRINT ENDP

;==========================================================================================================
; Procedure to print a character stored in AL
PRINT_CHAR PROC NEAR
    MOV AH, 02H                    ; Function 02H: Display character
    INT 21H                         ; Call DOS interrupt
    RET
PRINT_CHAR ENDP

;==========================================================================================================
; Clear screen
CLS PROC NEAR
    MOV AX, 0600H                   ; Function 06H - Scroll up (clear screen)
    MOV BH, 07H                     ; Attribute (07H = light gray on black background)
    MOV CX, 0000H                   ; Upper-left corner (row 0, column 0)
    MOV DX, 184FH                   ; Lower-right corner (row 24, column 79)
    INT 10H                         ; Call BIOS video interrupt
    ; Reset cursor to (0, 0)
    MOV AH, 02H                    ; Function 02H - Set cursor position
    MOV BH, 00H                     ; Page number (0 = first page)
    MOV DH, 00H                     ; Row (0 = top row)
    MOV DL, 00H                     ; Column (0 = left column)
    INT 10H                         ; Call BIOS video interrupt
    RET
CLS ENDP

;==========================================================================================================
; Procedure to get a single character input
GET_INPUT PROC NEAR
    MOV AH, 01H                    ; Function 01H: Read character from standard input
    INT 21H
    RET
GET_INPUT ENDP

END MAIN