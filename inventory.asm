TITLE INVENTORY SYSTEM

.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    DB_TEMP                 DB      ?         ; Temporary data (could be for username/password)
    DW_TEMP                 DW      ?

    CRLF                    EQU     0DH, 0AH 
    MAINMENU_OPTIONS        DB      "1 - Staff Log In", CRLF, "2 - Staff Sign Up", CRLF, "0 - Exit", CRLF, "$"
    PROMPT_MSG              DB      CRLF, "Select an option: $"
    INVALID_OPTION_MSG      DB      CRLF, "Invalid option. Try again.", CRLF, "$"
    LOGIN_MSG               DB      CRLF, "Staff Log In is selected.", CRLF, "$"
    SIGNUP_MSG              DB      CRLF, "Staff Sign Up is selected.", CRLF, "$"
    USERNAME_PROMPT         DB      CRLF, "Enter username: $"
    PASSWORD_PROMPT         DB      CRLF, "Enter password: $"
    SIGNUP_SUCCESS          DB      CRLF, "Signup successful! Welcome, ", "$"
    
;==========================================================================================================
.CODE

MAIN PROC FAR
    MOV     AX, @DATA                  ; load data segment address to DS register
    MOV     DS, AX
    
    ; Main loop starts here
MAIN_LOOP:
    CALL    CLS

    LEA     DX, MAINMENU_OPTIONS        ; print main menu options
    CALL    PRINT

    LEA     DX, PROMPT_MSG              ; display prompt message
    CALL    PRINT

    CALL    GET_INPUT                    ; get user's input
    CMP     AL, '1'                      ; check if the user selected '1'
    JE      STAFF_LOGIN                  ; jump to staff login if '1'
    
    CMP     AL, '2'                      ; check if the user selected '2'
    JE      STAFF_SIGNUP                 ; jump to staff sign up if '2'
    
    CMP     AL, '0'                      ; check if the user selected '0'
    JE      EXIT_PROGRAM                 ; exit program if '0'

    ; Invalid option
    LEA     DX, INVALID_OPTION_MSG       ; display invalid option message
    CALL    PRINT
    JMP     MAIN_LOOP                    ; repeat the loop for another input

STAFF_LOGIN:
    ; Display staff login message
    LEA     DX, LOGIN_MSG
    CALL    PRINT
    JMP     MAIN_LOOP

STAFF_SIGNUP:
    ; Display staff signup message
    LEA     DX, SIGNUP_MSG
    CALL    PRINT

    ; Get username
    LEA     DX, USERNAME_PROMPT
    CALL    PRINT
    CALL    GET_INPUT                    ; Read username
    MOV     DB_TEMP, AL                 ; Store username (assuming one character for simplicity)

    ; Get password
    LEA     DX, PASSWORD_PROMPT
    CALL    PRINT
    CALL    GET_INPUT                    ; Read password
    MOV     DB_TEMP + 1, AL             ; Store password (assuming one character for simplicity)

    ; Confirm signup success
    LEA     DX, SIGNUP_SUCCESS
    CALL    PRINT
    ; Print the username to confirm (you may want to enhance this)
    MOV     DL, DB_TEMP                  ; Load username character
    MOV     AH, 02H                      ; Function to display character
    INT     21H

    JMP     MAIN_LOOP

EXIT_PROGRAM:
    MOV     AX, 4C00H                    ; request for program exit
    INT     21H

MAIN ENDP

;==========================================================================================================
; Procedure to get user input (single character)
GET_INPUT PROC NEAR
    MOV     AH, 01H                      ; function 01H: Read single character from stdin
    INT     21H                          ; store input in AL
    RET
GET_INPUT ENDP

;==========================================================================================================
; Procedure to print string (assumes DX holds address of string)
PRINT PROC NEAR
    MOV     AH, 09H                      ; function 09H: Print string to stdout
    INT     21H
    RET
PRINT ENDP

;==========================================================================================================
; Clear screen
CLS PROC NEAR
    MOV     AX, 0600H                    ; function 06H - Scroll up (clear screen)
    MOV     BH, 07H                      ; attribute (07H = light gray on black background)
    MOV     CX, 0000H                    ; upper-left corner (row 0, column 0)
    MOV     DX, 184FH                    ; lower-right corner (row 24, column 79)
    INT     10H                          ; call BIOS video interrupt
    ; reset cursor to (0, 0)
    MOV     AH, 02H                      ; function 02H - Set cursor position
    MOV     BH, 00H                      ; page number (0 = first page)
    MOV     DH, 00H                      ; row (0 = top row)
    MOV     DL, 00H                      ; column (0 = left column)
    INT     10H                          ; call BIOS video interrupt
    RET
CLS ENDP

;==========================================================================================================
END MAIN