TITLE INVENTORY SYSTEM

.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA

    WHOLE_NUM DW 12345
    UNIT_PRICE DB "000000", '$' 

    TEN_THOUSAND DW 10000
    THOUSAND    DW 1000
    HUNDRED     DW 100                  ; Constant for division
    TEN         DW 10                   ; Constant for division

    DB_TEMP				DB      ?         ; Temporary data (could be for username/password)
    DW_TEMP				DW      ?

	x EQU 4 ; No. of Attributes in Item
	y EQU 20 ; No. Of Items
	
	ITEM_ARRAY DB x * y DUP(?) ; Allocate space for the 2D array

    CRLF                    EQU     0DH, 0AH
	LongLine				DB  	"---------------------------------------------", CRLF, "$"
    MAINMENU_OPTIONS        DB      "1 - Staff Log In", CRLF, "2 - Staff Sign Up", CRLF, "0 - Exit", CRLF, "$"
    PROMPT_MSG              DB      CRLF, "Select an option: $"
    INVALID_OPTION_MSG      DB      CRLF, "Invalid option. Try again.", CRLF, "$"
    LOGIN_MSG               DB      CRLF, "Staff Log In is selected.", CRLF, "$"
    SIGNUP_MSG              DB      CRLF, "Staff Sign Up is selected.", CRLF, "$"
    USERNAME_PROMPT         DB      CRLF, "Enter username: $"
    PASSWORD_PROMPT         DB      CRLF, "Enter password: $"
    SIGNUP_SUCCESS          DB      CRLF, "Signup successful! Welcome, ", "$"

	ITEMMENU_OPTIONS		DB  	"1 - Add Item", CRLF, "2 - Modify item", CRLF, "3 - Delete item", CRLF, "0 - Exit", CRLF, "$"
	ITEMMODIFYMENU			DB  	"1 - Modify Name", CRLF,"2 - Modify Quantity", CRLF,"3 - Modify UnitPrice", CRLF, "0 - Exit", CRLF, "$"
	STOCK_REPORT_HEADER     DB      "---------------------------------------------", CRLF
                        	DB      "| ITEM ID | Name        | Count | UnitPrice |", CRLF, "$"
	STOCK_EACH				DB		"|         |             |       |           |", CRLF,"$"					;9, 13, 6, 11
    
;==========================================================================================================
.CODE

MAIN PROC FAR
    MOV     AX, @DATA                  ; load data segment address to DS register
    MOV     DS, AX
    
    ; Main loop starts here

    CALL    MAIN_MENU

EXIT_PROGRAM:
    MOV     AX, 4C00H                    ; request for program exit
    INT     21H

MAIN ENDP
;==========================================================================================================
; Login/ SignUp Menu
MAIN_MENU PROC NEAR
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
MAIN_MENU ENDP

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
; Print a numerical Value with decimel points
DOUBLE_VALUE PROC NEAR
    MOV SI, 0
    MOV AX, WHOLE_NUM
    XOR DX, DX

    CMP AX, TEN_THOUSAND
    JGE  TT
    CMP AX, THOUSAND
    JGE  T
    CMP AX, HUNDRED
    JL  END_DOUBLE_VALUE
    JMP H

TT: 
    DIV TEN_THOUSAND
    MOV UNIT_PRICE[SI], AL
    ADD UNIT_PRICE[SI], 30h
    INC SI
    MOV AX, DX
    XOR DX, DX
    JMP T

T:  
    DIV THOUSAND
    MOV UNIT_PRICE[SI], AL
    ADD UNIT_PRICE[SI], 30h
    INC SI
    MOV AX, DX
    XOR DX, DX
    JMP H

H:  
    DIV HUNDRED
    MOV UNIT_PRICE[SI], AL
    ADD UNIT_PRICE[SI], 30h
    INC SI
    MOV AX, DX

    XOR DX, DX
    MOV UNIT_PRICE[SI], ','
    DIV TEN
    INC SI
    MOV UNIT_PRICE[SI], AL
    ADD UNIT_PRICE[SI], 30h
    MOV AX, DX

    XOR DX, DX
    INC SI
    MOV UNIT_PRICE[SI], AL
    ADD UNIT_PRICE[SI], 30h

END_DOUBLE_VALUE:
    RET
DOUBLE_VALUE ENDP
;==========================================================================================================

END MAIN