.MODEL SMALL
.STACK 100H

.DATA
    CONTAIN_STRING DB 21 DUP('$')
    INPUT_BUFFER DB 21 DUP('$')       ; Buffer to store the user input, including terminating '$'
    PROMPT_MSG DB 'Enter a number (max 20 digits): $'
    RESULT_MSG DB 0Dh, 0Ah, 'You entered: $'
    BACKSPACE_MSG DB 08H, ' ', 08H    ; Control characters to handle backspace

.CODE
    MAIN PROC
        MOV AX, @DATA                 ; Initialize data segment
        MOV DS, AX

        ; Display the prompt
        LEA DX, PROMPT_MSG
        MOV AH, 09H
        INT 21H

        ; Initialize buffer for input
        LEA DI, INPUT_BUFFER          ; Point DI to the buffer
        MOV CX, 20                    ; Set the max input length (20 digits)

        ; Call the input procedure
        CALL GET_STRING_INPUT_INT

        ; Display the result message
        LEA DX, RESULT_MSG
        MOV AH, 09H
        INT 21H

        ; Display the entered number
        LEA DX, INPUT_BUFFER          ; Point to the buffer with input string
        MOV AH, 09H
        INT 21H

        ; Exit program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP

    ;==========================================================================================================
    ; Procedure to get a string input of only numeric characters (integers) with backspace support
    GET_STRING_INPUT_INT PROC NEAR
    GET_STRING_INPUT_INT_START:
        ; Display the prompt
        LEA DX, PROMPT_MSG
        MOV AH, 09H
        INT 21H

        GET_STRING_INPUT_LOOP:
        MOV AH, 01H                      ; Function to read character from standard input
        INT 21H                          ; Call DOS interrupt
        CMP AL, 0Dh                      ; Check if Enter key is pressed (Carriage Return)
        JE GET_STRING_INPUT_DONE_INPUT    ; If Enter key, jump to done input

        CMP AL, 08H                      ; Check if Backspace is pressed
        JE HANDLE_BACKSPACE               ; Jump to handle backspace if true

        ; Check if the input is a numeric character (between '0' and '9')
        CMP AL, '0'                      ; Compare with '0'
        JL GET_STRING_INPUT_LOOP          ; If less than '0', ignore input
        CMP AL, '9'                      ; Compare with '9'
        JG GET_STRING_INPUT_LOOP          ; If greater than '9', ignore input

        ; Store the numeric character
        MOV [DI], AL                     ; Store the character in destination (buffer)
        INC DI                           ; Move to the next position in the buffer
        DEC CX                           ; Decrease CX (max input length counter)
        MOV AH, 02H                      ; DOS function to output a single character
        INT 21H                          ; Echo the input back to the screen
        JNZ GET_STRING_INPUT_LOOP        ; Continue loop if CX not zero

        JMP GET_STRING_INPUT_DONE_INPUT   ; Jump to done if max length is reached

        ; Handle Backspace
        HANDLE_BACKSPACE:
        CMP DI, OFFSET INPUT_BUFFER             ; Check if buffer is empty (cannot backspace further)
        JLE GET_STRING_INPUT_LOOP        ; If at start, ignore backspace

        DEC DI                           ; Move back one position in the buffer
        INC CX                           ; Increase CX since a character was removed
        LEA DX, BACKSPACE_MSG            ; Output backspace, space, backspace to erase character
        MOV AH, 09H
        INT 21H
        JMP GET_STRING_INPUT_LOOP        ; Continue input loop

        ; Done input
     GET_STRING_INPUT_DONE_INPUT:
    MOV BYTE PTR [DI], '$'            ; Set end of string (DOS string terminator)

        ; Load address into SI to check for digits
        LEA SI, INPUT_BUFFER               ; Load the address of INPUT_BUFFER into SI
        MOV CL, '0'                       ; Load character to search for
        CALL CONTAINS_DIGIT               ; Check for digits
        CMP AL, 0                          ; Check if any digit was found
        JE  GET_STRING_INPUT_INT_START     ; If no digit found, restart input

        RET
    GET_STRING_INPUT_INT ENDP

    ; Got Contains (ASSUME CONTAIN_STRING Contains String, And CL contains Char)
CONTAINS_DIGIT PROC
    MOV     SI, 0                  ; Start index at 0

CHECK_CONTAIN_LOOP:
    MOV     AL, CONTAIN_STRING[SI] ; Load current character from string
    CMP     AL, CL                 ; Compare with character to find
    JE      FOUND                  ; Jump if equal (found character)

    CMP AL, '0'                      ; Compare with '0'
    JL CONTAIN_INT_SKIP
    CMP AL, '9'                      ; Compare with '9'
    JG CONTAIN_INT_SKIP
    JMP FOUND
CONTAIN_INT_SKIP:

    CMP     AL, '$'                ; Check for string terminator
    JE      NOT_FOUND              ; Jump to not found if we reach terminator

    INC     SI                     ; Move to next character
    JMP     CHECK_CONTAIN_LOOP             ; Repeat loop

NOT_FOUND:
    ; If the character is not found, set AL to 0 (false)
    XOR     AL, AL                 ; Set AL to 0 (false)
    RET

FOUND:
    ; If the character is found, set AL to 1 (true)
    MOV     AL, 1                   ; Set AL to 1 (true)
    RET
CONTAINS_DIGIT ENDP

END MAIN