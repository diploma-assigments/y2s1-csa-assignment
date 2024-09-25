.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    DB_TEMP                 DB      20 DUP(0) ; Temporary data for username/password (20 bytes max)
    DB_TEMP_PASSWORD        DB      20 DUP(0) ; Separate storage for password
    DW_TEMP				    DW      ?
    COMPARE_STRING1         DB      21 DUP(0)
    COMPARE_STRING2         DB      21 DUP(0)

    CRLF                    EQU     0DH, 0AH 
    NEWLINE                 DB      0DH, 0AH, "$"

    ; User inputs
    OPTION_INPUT            DB      ?         ; Store selected option
    STAFF_ID_INPUT          DB      8 DUP(0)
    STAFF_PASSWORD_INPUT    DB      21 DUP(0)
    
    ; Data stores
    STAFF_SLOT_1_EMPTY      DB      0
    STAFF_SLOT_1_ID         DB      "STF0001$"
    STAFF_SLOT_1_PASSWORD   DB      "pass@123$"
    
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
    OPTION_PROMPT           DB      CRLF, "Select an option: $"
    INVALID_OPTION_MSG      DB      CRLF, "Invalid option. Try again.", CRLF, "$"
    LOGIN_HEADER            DB      CRLF, "Staff Log In:", CRLF, "$"
    SIGNUP_HEADER           DB      CRLF, "Staff Sign Up:", CRLF, "$"
    LOGIN_SUCCESS_MSG       DB      CRLF, "Login successful!", "$"
    LOGIN_FAILED_MSG        DB      CRLF, "Invalid credentials, please try again.$"
    SIGNUP_SUCCESS_MSG      DB      CRLF, "Signup successful! Welcome, ", "$"
    PROGRAM_EXIT_MSG        DB      CRLF, "Thank you for using the inventory system.$"
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

    LEA     DX, OPTION_PROMPT              
    CALL    PRINT                       ; get char option
    CALL    GET_CHAR_INPUT            
    MOV     OPTION_INPUT, AL          

    CMP     OPTION_INPUT, '1'        
    JE      CALL_STAFF_LOGIN                 
    CMP     OPTION_INPUT, '2'        ; jump to relavent menu
    JE      CALL_STAFF_SIGNUP                 
    CMP     OPTION_INPUT, '0'        
    JE      CALL_EXIT_PROGRAM                

    CALL_STAFF_LOGIN:
    CALL STAFF_LOGIN
    CALL_STAFF_SIGNUP:
    ;CALL STAFF_SIGNUP
    CALL_EXIT_PROGRAM:
    CALL EXIT_PROGRAM

    ; Invalid option
    LEA     DX, INVALID_OPTION_MSG       
    CALL    PRINT
    JMP     MAIN_LOOP                 
    
;==========================================================================================================
STAFF_LOGIN PROC NEAR
    CALL    CLS

    ; display menu header
    LEA     DX, LOGIN_HEADER
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

    ; Check if staff id is valid
    LEA     SI, STAFF_ID_INPUT
    LEA     DI, COMPARE_STRING1     ; set compare string 1 = staff_id_input
    CALL    COPY_STRING

    ; staff slot 1
    LEA     SI, STAFF_SLOT_1_ID
    LEA     DI, COMPARE_STRING2  
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                   
    JE      STAFF_LOGIN_CHECK_PASSWORD
    ; staff slot 2
    LEA     SI, STAFF_SLOT_2_ID
    LEA     DI, COMPARE_STRING2     
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                   
    JE      STAFF_LOGIN_CHECK_PASSWORD
    ; staff slot 3
    LEA     SI, STAFF_SLOT_3_ID
    LEA     DI, COMPARE_STRING2     
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                   
    JE      STAFF_LOGIN_CHECK_PASSWORD
    ; staff slot 4
    LEA     SI, STAFF_SLOT_4_ID
    LEA     DI, COMPARE_STRING2     
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                   
    JE      STAFF_LOGIN_CHECK_PASSWORD

    JMP     STAFF_LOGIN_CREDENTIALS_INVALID

    ; Check if staff password is valid
    STAFF_LOGIN_CHECK_PASSWORD:
    LEA     SI, STAFF_PASSWORD_INPUT
    LEA     DI, COMPARE_STRING1     ; set compare string 1 = staff_password_input
    CALL    COPY_STRING

    ; staff 1
    LEA     SI, STAFF_SLOT_1_PASSWORD
    LEA     DI, COMPARE_STRING2 
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                  
    JE      STAFF_LOGIN_CREDENTIALS_VALID
    ; staff 2
    LEA     SI, STAFF_SLOT_1_PASSWORD
    LEA     DI, COMPARE_STRING2 
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                  
    JE      STAFF_LOGIN_CREDENTIALS_VALID
    ; staff 3
    LEA     SI, STAFF_SLOT_1_PASSWORD
    LEA     DI, COMPARE_STRING2 
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                  
    JE      STAFF_LOGIN_CREDENTIALS_VALID
    ; staff 4
    LEA     SI, STAFF_SLOT_1_PASSWORD
    LEA     DI, COMPARE_STRING2 
    CALL    COPY_STRING
    CALL    COMPARE_STRINGS
    CMP     AL, 1                  
    JE      STAFF_LOGIN_CREDENTIALS_VALID

    JMP     STAFF_LOGIN_CREDENTIALS_INVALID

    STAFF_LOGIN_CREDENTIALS_VALID:
    LEA     DX, LOGIN_SUCCESS_MSG
    CALL    PRINT
    CALL    GET_CHAR_INPUT
    JMP     MAIN_LOOP                    ; Go back to main loop

    STAFF_LOGIN_CREDENTIALS_INVALID:
    LEA     DX, LOGIN_FAILED_MSG
    CALL    PRINT
    CALL    GET_CHAR_INPUT
    JMP     MAIN_LOOP                    ; Go back to main loop
STAFF_LOGIN ENDP

;==========================================================================================================
; STAFF_SIGNUP PROC NEAR
;     CALL    CLS

;     ; Display staff signup message
;     LEA     DX, SIGNUP_HEADER
;     CALL    PRINT

;     ; Get username
;     LEA     DX, USERNAME_PROMPT
;     CALL    PRINT
;     MOV     BX, OFFSET DB_TEMP          ; Address of the username storage
;     CALL    GET_STRING                   ; Read username

;     ; Get password
;     LEA     DX, PASSWORD_PROMPT
;     CALL    PRINT
;     MOV     BX, OFFSET DB_TEMP_PASSWORD  ; Address of the password storage
;     CALL    GET_STRING                   ; Read password

;     ; Confirm signup success      DB      CRLF, ""
;     LEA     DX, SIGNUP_SUCCESS_MSG   CALL    PRINT

;     ; Print the username to confirm
;     LEA     DX, DB_TEMP                  ; Load address of username
;     CALL    PRINT                        ; Print the username

;     JMP     MAIN_LOOP
; STAFF_SIGNUP ENDP

;==========================================================================================================
EXIT_PROGRAM PROC NEAR
    CALL    CLS

    ; Print program exit message
    LEA     DX, PROGRAM_EXIT_MSG
    CALL    PRINT

    MOV     AX, 4C00H                    ; request for program exit
    INT     21H
EXIT_PROGRAM ENDP

MAIN ENDP


;==========================================================================================================
; Generalized procedure to copy a string from source to destination
; Parameters: 
; LEA SI, <from_string>
; LEA DI, <to_string>
COPY_STRING PROC
    PUSH SI                     ; Save SI (source index)
    PUSH DI                     ; Save DI (destination index)

COPY_LOOP:
    MOV     AL, [SI]             ; Load current character from source string
    MOV     [DI], AL             ; Copy it to destination string
    CMP     AL, '$'              ; Check for the string terminator
    JE      COPY_DONE            ; Stop copying if end of string is reached

    INC     SI                   ; Increment source index
    INC     DI                   ; Increment destination index
    JMP     COPY_LOOP            ; Repeat the loop

COPY_DONE:
    POP DI                       ; Restore DI
    POP SI                       ; Restore SI
    RET
COPY_STRING ENDP

;==========================================================================================================
COMPARE_STRINGS PROC NEAR
    MOV     SI, 0                      ; Reset index for comparison

COMPARE_STRINGS_LOOP:
    MOV     AL, COMPARE_STRING1[SI]     ; Load current character from first string
    MOV     BL, COMPARE_STRING2[SI]     ; Load current character from second string

    CMP     AL, BL                      ; Compare characters
    JNE     COMPARE_STRINGS_NOT_EQUAL   ; Jump if not equal

    CMP     AL, '$'                     ; Check if end of first string
    JE      COMPARE_STRINGS_EQUAL       ; Jump if equal (both strings ended)

    CMP     BL, '$'                     ; Check if end of second string
    JE      COMPARE_STRINGS_NOT_EQUAL   ; Jump if one string ended

    INC     SI                          ; Increment index
    JMP     COMPARE_STRINGS_LOOP        ; Repeat loop

COMPARE_STRINGS_NOT_EQUAL:
    MOV     AL, 0                       ; Set AL to 0 for not equal
    RET

COMPARE_STRINGS_EQUAL:
    MOV     AL, 1                       ; Set AL to 1 for equal
    RET
COMPARE_STRINGS ENDP

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
; Procedure to print string (assumes DX holds address of string)
PRINTLN PROC NEAR
    MOV     AH, 09H                      ; function 09H: Print string to stdout
    INT     21H
    LEA     DX, NEWLINE
    INT     21H
    RET
PRINTLN ENDP

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