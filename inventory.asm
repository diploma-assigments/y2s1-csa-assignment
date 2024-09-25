.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    DB_TEMP                 DB      20 DUP(0) ; Temporary data for username/password (20 bytes max)
    DB_TEMP_PASSWORD        DB      20 DUP(0) ; Separate storage for password
    DW_TEMP				    DW      ?
    SELECTED_OPTION         DB      ?         ; Store selected option
    CRLF                    EQU     0DH, 0AH 

    MAINMENU_OPTIONS        DB      "1 - Staff Log In", CRLF, "2 - Staff Sign Up", CRLF, "0 - Exit", CRLF, "$"
    PROMPT_MSG              DB      CRLF, "Select an option: $"
    INVALID_OPTION_MSG      DB      CRLF, "Invalid option. Try again.", CRLF, "$"
    LOGIN_MSG               DB      CRLF, "Staff Log In:", CRLF, "$"
    SIGNUP_MSG              DB      CRLF, "Staff Sign Up:", CRLF, "$"
    PROGRAM_EXIT_MSG        DB      CRLF, "Thank you for using the inventory system.$"
    SIGNUP_SUCCESS          DB      CRLF, "Signup successful! Welcome, ", "$"
    USERNAME_PROMPT         DB      CRLF, "Enter username: $"
    PASSWORD_PROMPT         DB      CRLF, "Enter password: $"
    
    LongLine				DB  	"---------------------------------------------", CRLF, "$"
    ITEMMENU_OPTIONS		DB  	"1 - Add Item", CRLF, "2 - Modify item", CRLF, "3 - Delete item", CRLF, "0 - Exit", CRLF, "$"
	ITEMMODIFYMENU			DB  	"1 - Modify Name", CRLF,"2 - Modify Quantity", CRLF,"3 - Modify UnitPrice", CRLF, "0 - Exit", CRLF, "$"
	STOCK_REPORT_HEADER     DB      "---------------------------------------------", CRLF
                        	DB      "| ITEM ID | Name        | Count | UnitPrice |", CRLF, "$"
	STOCK_EACH				DB		"|         |             |       |           |", CRLF,"$"					;9, 13, 6, 11

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
    JE      EXIT_PROGRAM                 ; exit program if '0'

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
    MOV     BX, OFFSET DB_TEMP          ; Address of the username storage
    CALL    GET_STRING                   ; Read username

    ; Get password
    LEA     DX, PASSWORD_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET DB_TEMP_PASSWORD  ; Address of the password storage
    CALL    GET_STRING                   ; Read password

    ; Confirm login attempt
    LEA     DX, SIGNUP_SUCCESS           ; Use the success message to confirm login attempt
    CALL    PRINT
    
    ; Optionally, print the username to confirm
    LEA     DX, DB_TEMP                  ; Load address of username
    CALL    PRINT                         ; Print the username

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

    JMP     MAIN_LOOP

EXIT_PROGRAM:
    CALL    CLS

    ; Print program exit message
    LEA     DX, PROGRAM_EXIT_MSG
    CALL    PRINT

    MOV     AX, 4C00H                    ; request for program exit
    INT     21H

MAIN ENDP

;==========================================================================================================
GET_STAFF_ID PROC NEAR
    MOV     CX, 7

    GET_STAFF_ID_LOOP:
    MOV     AH, 01H
    INT     21H
    // STORE INTO STAFF_ID[I]

    LOOP    GET_STAFF_ID_LOOP
    // SET STAFF_ID[8] AS $


GET_STAFF_ID ENDP
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
    MOV     CX, 20                       ; max length
    MOV     DI, BX                       ; DI points to the destination (string)
    
GET_STRING_LOOP:
    CALL    GET_INPUT                    ; Get a single character
    CMP     AL, 0DH                      ; Check if Enter key (carriage return) is pressed
    JE      END_GET_STRING               ; If yes, end the input loop

    STOSB                                 ; Store character in DB_TEMP or password storage
    LOOP    GET_STRING_LOOP              ; Loop until the max length is reached

END_GET_STRING:
    MOV     BYTE PTR [DI], 0             ; Null terminate the string
    RET
GET_STRING ENDP

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

END MAIN