.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    DB_TEMP                 DB      20 DUP(0) ; Temporary data for username/password (20 bytes max)
    DB_TEMP_PASSWORD        DB      20 DUP(0) ; Separate storage for password
    DW_TEMP				    DW      ?
    SELECTED_OPTION         DB      ?         ; Store selected option
    STAFF_ID_INPUT          DB      8 DUP(0)
    STAFF_PASSWORD_INPUT    DB      21 DUP(0)
    CRLF                    EQU     0DH, 0AH 
    NEWLINE                 DB      0DH, 0AH, "$"

    MAINMENU_OPTIONS DB "1 - Staff Log In", CRLF, "2 - Staff Sign Up", CRLF, "0 - Exit", CRLF, "$"
    PROMPT_MSG DB CRLF, "Select an option: $"
    INVALID_OPTION_MSG DB CRLF, "Invalid option. Try again.", CRLF, "$"
    LOGIN_MSG DB CRLF, "Staff Log In:", CRLF, "$"
    SIGNUP_MSG DB CRLF, "Staff Sign Up:", CRLF, "$"
    PROGRAM_EXIT_MSG DB CRLF, "Thank you for using the inventory system.$"
    SIGNUP_SUCCESS DB CRLF, "Signup successful! Welcome, ", "$"
    USERNAME_PROMPT DB CRLF, "Enter username: $"
    PASSWORD_PROMPT DB CRLF, "Enter password: $"
    successMsg DB "Data written successfully.$"
    errorMsg DB "Error writing to file.$"
	x EQU 4 ; No. of Attributes in Item
	y EQU 20 ; No. Of Items
	
	ITEM_ARRAY DB x * y DUP(?) ; Allocate space for the 2D array
    ; file operations
    STAFF_FILE              DB      "staff.txt", 0
    FILE_HANDLE             DW      ?
    
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
    MOV     SELECTED_OPTION, AL          ; Store the input for checking

    CMP     SELECTED_OPTION, '1'        ; check if the user selected '1'
    JE      STAFF_LOGIN                  ; jump to staff login if '1'

    CMP     SELECTED_OPTION, '2'        ; check if the user selected '2'
    JE      STAFF_SIGNUP                 ; jump to staff sign up if '2'

    CMP     SELECTED_OPTION, '0'        ; check if the user selected '0'
    JMP      EXIT_PROGRAM                 ; exit program if '0'

    ; Invalid option
    LEA     DX, INVALID_OPTION_MSG       ; display invalid option message
    CALL    PRINT
    JMP     MAIN_LOOP                    ; repeat the loop for another input

; Display staff login message
STAFF_LOGIN:
    CALL    CLS

    LEA     DX, LOGIN_MSG
    CALL    PRINT

    ; Get username
    LEA     DX, USERNAME_PROMPT
    CALL    PRINT
    MOV     CX, 7
    LEA     DI, STAFF_ID_INPUT
    CALL    GET_STRING_INPUT

    ; Get password
    LEA     DX, PASSWORD_PROMPT
    CALL    PRINT
    MOV     CX, 20
    LEA     DI, STAFF_PASSWORD_INPUT
    CALL    GET_STRING_INPUT

    LEA     DX, STAFF_ID_INPUT
    CALL    PRINT
    CALL    PRINT_NEW_LINE
    LEA     DX, STAFF_PASSWORD_INPUT
    CALL    PRINT

    MOV AH, 01h
    INT 21H
    ; Confirm login attempt
    LEA     DX, SIGNUP_SUCCESS           ; Use the success message to confirm login attempt
    CALL    PRINT

    ; Add a confirmation message
    DB 'Login successful! Welcome back, ', 0
    CALL    PRINT                         ; Print the confirmation message

    JMP     MAIN_LOOP                    ; Go back to main loop

STAFF_SIGNUP:
    CALL    CLS

    ; Display staff signup message
    LEA     DX, SIGNUP_MSG
    CALL    PRINT

    ; Get username
    LEA     DX, USERNAME_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET DB_TEMP          ; Address of the username storage
    CALL    GET_STRING                   ; Read username

    ; Get password
    LEA     DX, PASSWORD_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET DB_TEMP_PASSWORD  ; Address of the password storage
    CALL    GET_STRING                   ; Read password

    ; Confirm signup success
    LEA     DX, SIGNUP_SUCCESS
    CALL    PRINT
    
    ; Print the username to confirm
    LEA     DX, DB_TEMP                  ; Load address of username
    CALL    PRINT                        ; Print the username

    ; Add a confirmation message
    DB 'Signup successful! Welcome, ', 0
    CALL    PRINT                         ; Print the confirmation message

    JMP     MAIN_LOOP

EXIT_PROGRAM PROC NEAR
    CALL    CLS

    ; Print program exit message
    LEA     DX, PROGRAM_EXIT_MSG
    CALL    PRINT

    MOV     AX, 4C00H                    ; request for program exit
    INT     21H
EXIT_PROGRAM ENDP

<<<<<<< HEAD
=======
MAIN ENDP

;==========================================================================================================
; MOV CX, MAXLENGTH
; LEA DI, <VAR_NAME (var to store into)>
GET_STRING_INPUT PROC NEAR
    GET_STRING_INPUT_LOOP:
    MOV AH, 01H                      ; Function to read character from standard input
    INT 21H                          ; Call DOS interrupt
    CMP AL, 0Dh                      ; Check if Enter key is pressed (Carriage Return)
    JE GET_STRING_INPUT_DONE_INPUT                    ; If Enter key, jump to done input
    MOV [DI], AL                     ; Store the character in STAFF_ID
    INC DI                           ; Move to the next position in STAFF_ID
    LOOP GET_STRING_INPUT_LOOP       ; Repeat until CX is 0

    GET_STRING_INPUT_DONE_INPUT:
    MOV BYTE PTR [DI], '$'   ; Set end of string

    RET
GET_STRING_INPUT ENDP
>>>>>>> b2e08446cbccd6509e16a4695a6fca57566086a0
;==========================================================================================================
; Procedure to get user input (single character)
GET_INPUT PROC NEAR
    MOV     AH, 01H                      ; function 01H: Read single character from stdin
    INT     21H                          ; store input in AL
    RET
GET_INPUT ENDP

;==========================================================================================================
; Procedure to get a string from user input (up to 20 characters)
GET_STRING PROC NEAR
    MOV     CX, 20                       ; max length (20 characters)
    MOV     DI, BX                       ; DI points to the destination (string)
    XOR     SI, SI                       ; Initialize counter for string length

GET_STRING_LOOP:
    CALL    GET_INPUT                     ; Get a single character
    CMP     AL, 08H                      ; Check if Backspace key is pressed
    JE      HANDLE_BACKSPACE              ; If yes, handle backspace

    CMP     AL, 0DH                       ; Check if Enter key (carriage return) is pressed
    JE      END_GET_STRING                ; If yes, end the input loop

    CMP     SI, 19                        ; Check if max length reached (allowing space for null terminator)
    JAE     GET_STRING_LOOP               ; If max length reached, ignore further input

    STOSB                                  ; Store character in the buffer
    INC     SI                             ; Increment the string length counter
    JMP     GET_STRING_LOOP               ; Loop back to get the next character

HANDLE_BACKSPACE:
    CMP     SI, 0                         ; Check if the string is empty
    JE      HANDLE_BACKSPACE_END           ; If yes, do nothing

    CMP     SI, 1                         ; Check if we're at the beginning of the string
    JB      HANDLE_BACKSPACE_END           ; If yes, do nothing

    DEC     SI                             ; Decrement the string length counter
    DEC     DI                             ; Move DI to the last character's position

    ; Print carriage return and line feed to move cursor to beginning of line
    MOV     DL, 0DH                      ; Carriage return character
    MOV     AH, 02H                      ; Function 02H: Print character to stdout
    INT     21H
    MOV     DL, 0AH                      ; Line feed character
    MOV     AH, 02H                      ; Function 02H: Print character to stdout
    INT     21H

    ; Print the prompt message again
    LEA     DX, USERNAME_PROMPT
    CALL    PRINT

    ; Print the updated string
    LEA     DX, DB_TEMP
    CALL    PRINT

    ; Move the cursor to the end of the string
    MOV     AH, 02H                       ; Function 02H: Set cursor position
    MOV     BH, 00H                       ; Page number (0 = first page)
    MOV     DH, 0                          ; Row (0 = top row)
    MOV     DL, 13                         ; Start column (adjust as necessary)

    ; Use an intermediate register to calculate the new cursor position
MOV     AX, 0                          ; Clear AX
MOV     AL, DL                         ; Move the starting column to AL
ADD     AL, SI                         ; Add the length of the string to the column

; Ensure that AL does not exceed 80 (if you're working in an 80-column mode)
CMP     AL, 80
JL      SetCursor                      ; If less than 80, set cursor
MOV     AL, 79                         ; Otherwise, set to max column

SetCursor:
MOV     DL, AL                         ; Move the new column position to DL
INT     10H                           ; Call BIOS video interrupt
HANDLE_BACKSPACE_END:
    JMP     GET_STRING_LOOP               ; Loop back to get the next character

END_GET_STRING:
    MOV     BYTE PTR [DI], 0              ; Null terminate the string
    RET
GET_STRING ENDP

;==========================================================================================================
PRINT_NEW_LINE PROC NEAR
    MOV     AH, 09H
    LEA     DX, NEWLINE
    INT     21H
    RET
PRINT_NEW_LINE ENDP

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
; Write to file (Function 40h)
;WRITE_TO_FILE PROC NEAR
;    mov ah, 40h            ; Write to file
;    mov bx, filehandle     ; File handle
;    lea dx, buffer         ; DS:DX -> Buffer
;    mov cx, buffersize     ; Number of bytes to write
;    int 21h                ; DOS interrupt
;    jc error               ; Jump if carry flag is set (error)
;WRITE_TO_FILE ENDP
END MAIN