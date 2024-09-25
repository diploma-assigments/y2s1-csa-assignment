.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    DB_TEMP                 DB      20 DUP(0) ; Temporary data for username/password (20 bytes max)
    DB_TEMP_PASSWORD        DB      20 DUP(0) ; Separate storage for password
    DW_TEMP				    DW      ?
    CRLF                    EQU     0DH, 0AH 
    NEWLINE                 DB      0DH, 0AH, "$"

    ; User inputs
    OPTION_INPUT            DB      ?         ; Store selected option
    STAFF_ID_INPUT          DB      8 DUP(0)
    STAFF_PASSWORD_INPUT    DB      21 DUP(0)
    
    ; Data stores
    STAFF_SLOT_1_EMPTY      DB      0
    STAFF_SLOT_1_ID         DB      8 DUP(0)
    STAFF_SLOT_1_PASSWORD   DB      21 DUP(0)
    
    STAFF_SLOT_2_EMPTY      DB      1
    STAFF_SLOT_2_ID         DB      8 DUP(0)
    STAFF_SLOT_2_PASSWORD   DB      21 DUP(0)

    STAFF_SLOT_3_EMPTY      DB      1
    STAFF_SLOT_3_ID         DB      8 DUP(0)
    STAFF_SLOT_3_PASSWORD   DB      21 DUP(0)

    STAFF_SLOT_4_EMPTY      DB      1
    STAFF_SLOT_4_ID         DB      8 DUP(0)
    STAFF_SLOT_4_PASSWORD   DB      21 DUP(0)
    
    ; Messages
    MAINMENU_OPTION_MSG     DB      "1 - Staff Log In", CRLF, "2 - Staff Sign Up", CRLF, "0 - Exit", CRLF, "$"
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
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;==========================================================================================================
.CODE

MAIN PROC FAR
    MOV     AX, @DATA                  ; load data segment address to DS register
    MOV     DS, AX
    
    ; Program loop
    MAIN_LOOP:
    CALL    CLS

    LEA     DX, MAINMENU_OPTION_MSG        ; print main menu options
    CALL    PRINT

    LEA     DX, PROMPT_MSG              
    CALL    PRINT                       ; get char option
    CALL    GET_CHAR_INPUT            
    MOV     OPTION_INPUT, AL          

    CMP     OPTION_INPUT, '1'        
    JE      STAFF_LOGIN                  
    CMP     OPTION_INPUT, '2'        ; jump to relavent menu
    JE      STAFF_SIGNUP                 
    CMP     OPTION_INPUT, '0'        
    JE      EXIT_PROGRAM                

    ; Invalid option
    LEA     DX, INVALID_OPTION_MSG       
    CALL    PRINT
    JMP     MAIN_LOOP                 
    
;==========================================================================================================
    STAFF_LOGIN:
    CALL    CLS

    ; display menu header
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

    ; check if staff id is valid
    CMP     STAFF_SLOT_1_ID, STAFF_ID_INPUT
    JE      STAFF_LOGIN_ID_VALID
    CMP     STAFF_SLOT_2_ID, STAFF_ID_INPUT
    JE      STAFF_LOGIN_ID_VALID
    CMP     STAFF_SLOT_3_ID, STAFF_ID_INPUT
    JE      STAFF_LOGIN_ID_VALID
    CMP     STAFF_SLOT_4_ID, STAFF_ID_INPUT
    JE      STAFF_LOGIN_ID_VALID
    JMP     STAFF_LOGIN_ERROR

    ; check if staff password is valid
    STAFF_LOGIN_ID_VALID:
    CMP     STAFF_SLOT_1_PASSWORD, STAFF_PASSWORD_INPUT
    JE      STAFF_LOGIN_ID_VALID
    CMP     STAFF_SLOT_2_PASSWORD, STAFF_PASSWORD_INPUT
    JE      STAFF_LOGIN_ID_VALID
    CMP     STAFF_SLOT_3_PASSWORD, STAFF_PASSWORD_INPUT
    JE      STAFF_LOGIN_ID_VALID
    CMP     STAFF_SLOT_4_PASSWORD, STAFF_PASSWORD_INPUT
    JE      STAFF_LOGIN_ID_VALID
    JMP     STAFF_LOGIN_ERROR

    STAFF_LOGIN_PASSWORD_VALID:
    LEA     DX, "LOGIN SUCESS!$"
    CALL    PRINT
    MOV AH, 01h
    INT 21H
    JMP     MAIN_LOOP                    ; Go back to main loop

    JMPSTAFF_LOGIN_ERROR:
        LEA     DX, "Invalid creds!$"
    CALL    PRINT
    MOV AH, 01h
    INT 21H
    JMP     MAIN_LOOP                    ; Go back to main loop

;==========================================================================================================
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
;==========================================================================================================
; get sigle character user input
GET_CHAR_INPUT PROC NEAR
    MOV     AH, 01H                      ; function 01H: Read single character from stdin
    INT     21H                          ; store input in AL
    RET
GET_CHAR_INPUT ENDP

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

END MAIN