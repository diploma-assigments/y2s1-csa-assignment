.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
    COMPARE_STRING1         DB      21 DUP(0)
    COMPARE_STRING2         DB      21 DUP(0)

    CRLF                    EQU     0DH, 0AH 
    NEWLINE                 DB      0DH, 0AH, "$"

    ; User inputs
    OPTION_INPUT            DB      ?         ; Store selected option
    STAFF_ID_INPUT          DB      8 DUP(0)
    STAFF_PASSWORD_INPUT    DB      21 DUP(0)
    
    ; Data stores
    STAFF_SLOT_FULL         DB      0

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
    STAFF_CREATE_FULL_MSG   DB      CRLF, "No more slots to signup staff.$"

    DW_TEMP				DW      ?

    ITEM_ID                 DB      1
    DIGITS                  DB      '0000$'
    MESSAGE                 DB      'Formatted number: $'

    DB_TEMP_NAME             DB      20 DUP(0) ; Temporary data for username/password (20 bytes max)
    DB_TEMP_QUANTITY         DB      4 DUP(0) ; Separate storage for password
    DB_TEMP_UNITPRICE        DB      6 DUP(0)

    ITEM_SLOT_FULL         DB      0



    





    ITEM_SLOT_1_EMPTY      DB      0
    ITEM_SLOT_1_ID         DB      '0001$'
    ITEM_SLOT_1_Quantity   DB      123
    ITEM_SLOT_1_UNITPRICE  DW      12467

    ITEM_SLOT_2_EMPTY      DB      1
    ITEM_SLOT_2_ID         DB      '0002$'
    ITEM_SLOT_2_Quantity   DB      8 DUP(0)
    ITEM_SLOT_2_UNITPRICE  DW      21 DUP(0)

    ITEM_SLOT_3_EMPTY      DB      1
    ITEM_SLOT_3_ID         DB      '0003$'
    ITEM_SLOT_3_Quantity   DB      8 DUP(0)
    ITEM_SLOT_3_UNITPRICE  DW      21 DUP(0)

    ITEM_SLOT_4_EMPTY      DB      1
    ITEM_SLOT_4_ID         DB      '0004$'
    ITEM_SLOT_4_Quantity   DB      8 DUP(0)
    ITEM_SLOT_4_UNITPRICE  DW      21 DUP(0)


    WHOLE_NUM           DW      12345
    TEN_THOUSAND        DW      10000
    THOUSAND            DW      1000
    HUNDRED             DW      100
    TEN                 DW      10

    UNIT_PRICE              DB      "123456", '$'  ; String to check for comma
    CONTAIN_STRING1          DB      21 DUP('$')
    CONTAIN_STRING2         DB      21 DUP('$')
    STRING_BUFFER DB 21 DUP(0) ; Allocate space for the string (20 chars + 1 for null terminator)


    ARRAY db 20,?,8 dup ("$")

    CRLF                    EQU     0DH, 0AH
	LONGLINE				DB  	"---------------------------------------------", CRLF, "$"

    SELECTED_OPTION         DB      ?         ; Store selected option
    PROMPT_MSG              DB      CRLF, "Select an option: ", '$'


    LENGTH_OF_UNIT_PRICE    EQU     7  ; Length of "123,456"
    COMMA_FOUND_MSG         DB      "Comma found at index: ", '$'
    NO_COMMA_FOUND_MSG      DB      "No comma found in UNIT_PRICE.", '$'

    ; ITEM_MENU OPTIONS
    ITEM_MENU_LOGO          DB      "---------------------------------------------",CRLF
                            DB      "|                ITEM MENU                  |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'
    ITEMMENU_OPTIONS		DB  	"1 - Add Item", CRLF, "2 - Modify item", CRLF, "3 - Delete item", CRLF,"4 - View Stock Report", CRLF,"5 - View Trending Item Report", CRLF, "0 - Exit", CRLF, "$"

    ; ADD ITEM
    ADD_ITEM_LOGO           DB      "---------------------------------------------",CRLF
                            DB      "|              ADD ITEM MENU                |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'

    ITEM_NAME_PROMPT        DB      CRLF,"Enter ITEM Name      : $"
    ITEM_UNITPRICE_PROMPT   DB      CRLF,"Enter ITEM Unit Price: $"
    ITEM_QUANTITY_PROMPT    DB      CRLF,"Enter ITEM Quantity  : $"

    CONFIRM_ADD_MESSAGE_PROMPT  DB      CRLF,"[1] TO CONFIRM ADDING, [0] TO EXIT",CRLF,'$'
    CONFIRM_MOD_MESSAGE_PROMPT  DB      CRLF,"[1] TO CONFIRM ADDING, [0] TO EXIT",CRLF,'$'
    CONFIRM_DEL_MESSAGE_PROMPT  DB      CRLF,"[1] TO CONFIRM ADDING, [0] TO EXIT",CRLF,'$'

    ; MODIFY MENU
    MODIFY_ITEM_LOGO        DB      "---------------------------------------------",CRLF
                            DB      "|             MODIFY ITEM MENU              |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'
	ITEMMODIFY_OPTIONS		DB  	"1 - Modify Name", CRLF,"2 - Modify Quantity", CRLF,"3 - Modify UnitPrice", CRLF, "0 - Exit", CRLF, "$"

    ; DELETE MENU
    DELETE_ITEM_LOGO        DB      "---------------------------------------------",CRLF
                            DB      "|             DELETE ITEM MENU              |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'

    ITEM_ID_PROMPT          DB      CRLF,"0 - Exit", CRLF, "Enter ITEM Name      : $"

    ; STOCK_REPORT
	STOCK_REPORT_HEADER     DB      "-------------------------------------------------------", CRLF
                        	DB      "| ITEM ID | Name        | Count | UnitPrice |  Worth  |", CRLF
                            DB      "-------------------------------------------------------", CRLF, '$'
	STOCK_EACH				DB		"|         |             |       |           |         |", CRLF, '$'		;9, 13, 6, 11,7
    STOCK_REPORT_FOOTER     DB      "-------------------------------------------------------", CRLF
                    		DB		"|                        Total Stock Worth: |         |", CRLF
                            DB      "-------------------------------------------------------", CRLF, '$'          ;42, 7

    TESTSTR1    DB  "Test",'$'
    TESTSTR2    DB  "Test",'$'
    
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
    CALL STAFF_SIGNUP
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
    CALL    ITEM_MENU
    JMP     MAIN_LOOP                    ; Go back to main loop

    STAFF_LOGIN_CREDENTIALS_INVALID:
    LEA     DX, LOGIN_FAILED_MSG
    CALL    PRINT
    CALL    GET_CHAR_INPUT
    JMP     MAIN_LOOP                    ; Go back to main loop
STAFF_LOGIN ENDP

;==========================================================================================================
STAFF_SIGNUP PROC NEAR
    CALL    CLS

    CMP     STAFF_SLOT_FULL, 0
    JE      STAFF_CREATE_CONTINUE

    LEA     DX, STAFF_CREATE_FULL_MSG
    CALL    PRINTLN
    CALL    GET_CHAR_INPUT
    JMP     MAIN_LOOP

    STAFF_CREATE_CONTINUE:
    ; display menu header
    LEA     DX, SIGNUP_HEADER
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

    ; store the staff in an available slot
    LEA     SI, STAFF_ID_INPUT
    CMP     STAFF_SLOT_1_EMPTY, 1
    JE      STORE_INTO_STAFF_SLOT_1
    CMP     STAFF_SLOT_2_EMPTY, 1
    JE      STORE_INTO_STAFF_SLOT_2
    CMP     STAFF_SLOT_3_EMPTY, 1
    JE      STORE_INTO_STAFF_SLOT_3
    CMP     STAFF_SLOT_4_EMPTY, 1
    JE      STORE_INTO_STAFF_SLOT_4
    
    STORE_INTO_STAFF_SLOT_1:
    MOV     STAFF_SLOT_1_EMPTY, 0
    LEA     DI, STAFF_SLOT_1_ID
    CALL    COPY_STRING
    LEA     SI, STAFF_PASSWORD_INPUT
    LEA     DI, STAFF_SLOT_1_PASSWORD
    CALL    COPY_STRING
    JMP     COMPLETE_STORING_STAFF

    STORE_INTO_STAFF_SLOT_2:
    MOV     STAFF_SLOT_2_EMPTY, 0
    LEA     DI, STAFF_SLOT_2_ID
    CALL    COPY_STRING
    LEA     SI, STAFF_PASSWORD_INPUT
    LEA     DI, STAFF_SLOT_2_PASSWORD
    CALL    COPY_STRING
    JMP     COMPLETE_STORING_STAFF

    STORE_INTO_STAFF_SLOT_3:
    MOV     STAFF_SLOT_3_EMPTY, 0
    LEA     DI, STAFF_SLOT_3_ID
    CALL    COPY_STRING
    LEA     SI, STAFF_PASSWORD_INPUT
    LEA     DI, STAFF_SLOT_3_PASSWORD
    CALL    COPY_STRING
    JMP     COMPLETE_STORING_STAFF

    STORE_INTO_STAFF_SLOT_4:
    MOV     STAFF_SLOT_4_EMPTY, 0
    LEA     DI, STAFF_SLOT_4_ID
    CALL    COPY_STRING
    LEA     SI, STAFF_PASSWORD_INPUT
    LEA     DI, STAFF_SLOT_4_PASSWORD
    CALL    COPY_STRING
    JMP     COMPLETE_STORING_STAFF

    COMPLETE_STORING_STAFF:
    CMP     STAFF_SLOT_1_EMPTY, 0
    JE      COMPLETE_STORING_STAFF_END
    CMP     STAFF_SLOT_2_EMPTY, 0
    JE      COMPLETE_STORING_STAFF_END
    CMP     STAFF_SLOT_3_EMPTY, 0
    JE      COMPLETE_STORING_STAFF_END
    CMP     STAFF_SLOT_4_EMPTY, 0
    JE      COMPLETE_STORING_STAFF_END

    MOV     STAFF_SLOT_FULL, 1

    COMPLETE_STORING_STAFF_END:
    LEA     dx, LongLine
    call    PRINTLN
    lea     dx, STAFF_SLOT_2_ID
    call    PRINTLN
    lea     dx, STAFF_SLOT_2_PASSWORD
    call    PRINTLN
    call    GET_CHAR_INPUT

    JMP     MAIN_LOOP
STAFF_SIGNUP ENDP

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



; ITEM_MENU
ITEM_MENU PROC NEAR
ITEM_MENU_START:
    CALL    CLS
    LEA     DX, ITEM_MENU_LOGO
    CALL    PRINT
    LEA     DX, ITEMMENU_OPTIONS
    CALL    PRINT
    LEA     DX, PROMPT_MSG
    CALL    PRINT
    CALL    GET_CHAR_INPUT
    MOV     SELECTED_OPTION, AL

    CMP     SELECTED_OPTION, 30H
    JE      ITEM_MENU_OPTION0
    CMP     SELECTED_OPTION, 31H
    JE      ITEM_MENU_OPTION1
    CMP     SELECTED_OPTION, 32H
    JE      ITEM_MENU_OPTION2
    CMP     SELECTED_OPTION, 33H
    JE      ITEM_MENU_OPTION3
    CMP     SELECTED_OPTION, 34H
    JE      ITEM_MENU_OPTION4
    CMP     SELECTED_OPTION, 35H
    JE      ITEM_MENU_OPTION5
    JMP     ITEM_MENU_START

ITEM_MENU_OPTION1:
    CALL    ADD_ITEM_MENU
    JMP     ITEM_MENU_START
ITEM_MENU_OPTION2:
    CALL    MODIFY_ITEM_MENU
    JMP     ITEM_MENU_START

ITEM_MENU_OPTION3:
    CALL    DELETE_ITEM_MENU
    JMP     ITEM_MENU_START
ITEM_MENU_OPTION4:
    CALL    STOCK_REPORT
    JMP     ITEM_MENU_START
ITEM_MENU_OPTION5:
    ; CALL    STOCK_REPORT
    JMP     ITEM_MENU_START
ITEM_MENU_OPTION0:
    RET
ITEM_MENU ENDP

; ADD_ITEM_MENU
ADD_ITEM_MENU PROC NEAR
ADD_ITEM_MENU_START:
    CALL    CLS
    LEA     DX, ADD_ITEM_LOGO
    CALL    PRINT
ITEM_PROMPT1:
    ; READ A STRING
    LEA     DX, ITEM_NAME_PROMPT
    CALL    PRINT
    MOV     CX, 20
    LEA     DI, DB_TEMP_NAME
    CALL    GET_STRING_INPUT

    CMP     DB_TEMP_NAME[0], '$'
    JNE     ITEM_PROMPT2
    CALL    MOVEUPANDCLEAR
    JMP     ITEM_PROMPT1

ITEM_PROMPT2:
    LEA     DX, ITEM_QUANTITY_PROMPT
    CALL    PRINT
    MOV     CX, 20
    LEA     DI, DB_TEMP_QUANTITY
    CALL    GET_STRING_INPUT

    CMP     DB_TEMP_QUANTITY[0], '$'
    JNE     ITEM_PROMPT3
    CALL    MOVEUPANDCLEAR
    JMP     ITEM_PROMPT2
ITEM_PROMPT3:
    LEA     DX, ITEM_UNITPRICE_PROMPT
    CALL    PRINT
    MOV     CX, 20
    LEA     DI, DB_TEMP_UNITPRICE
    CALL    GET_STRING_INPUT

    CMP     DB_TEMP_UNITPRICE[0], '$'
    JNE     ADD_ITEM_EXIT
    CALL    MOVEUPANDCLEAR
    JMP     ITEM_PROMPT3
    CALL    CLEAR_BUFFER
    call    GET_CHAR_INPUT
    CALL    CONFIRMATION_MSG
ADD_ITEM_EXIT:
    RET
ADD_ITEM_MENU ENDP

; ADD_ITEM_CONFIRM
CONFIRMATION_MSG PROC NEAR
CONFIRM_START:
    CALL    CLS
    MOV     DX,0
    LEA     DX, CONFIRM_ADD_MESSAGE_PROMPT
    CALL    PRINT
    ; CALL    GET_CHAR_INPUT
    ; CMP     AL,0
    ; JE      CONFIRM_END
    ; CMP     AL,1
    ; JE      CONFIRM_ADD

    JMP     CONFIRM_START
CONFIRM_ADD:
    CALL    FORMAT_ID
    
CONFIRM_END:
    RET
CONFIRMATION_MSG ENDP

; MODIFY_ITEM_MENU
MODIFY_ITEM_MENU PROC NEAR
MODIFY_ITEM_MENU_START:
    CALL    CLS
    LEA     DX, MODIFY_ITEM_LOGO
    CALL    PRINT
    LEA     DX, ITEMMODIFY_OPTIONS
    CALL    PRINT
    LEA     DX, PROMPT_MSG
    CALL    PRINT
    CALL    GET_CHAR_INPUT
    MOV     SELECTED_OPTION, AL
    CMP     SELECTED_OPTION, 30H
    JE      MODIFY_EXIT
    CMP     SELECTED_OPTION, 31H
    JE      MODIFY_NAME
    CMP     SELECTED_OPTION, 32H
    JE      MODIFY_QUANTITY
    CMP     SELECTED_OPTION, 33H
    JE      MODIFY_UNITPRICE
    JMP     MODIFY_ITEM_MENU_START

MODIFY_NAME:
    CALL    CLS
    LEA     DX, ITEM_NAME_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING_INPUT
    LEA     DX, STRING_BUFFER
    CALL    PRINT
    JMP     MODIFY_ITEM_MENU_START
MODIFY_QUANTITY:
    CALL    CLS
    LEA     DX, ITEM_QUANTITY_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING_INPUT
    LEA     DX, STRING_BUFFER
    CALL    PRINT
    JMP     MODIFY_ITEM_MENU_START
MODIFY_UNITPRICE:
    CALL    CLS
    LEA     DX, ITEM_UNITPRICE_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING_INPUT
    LEA     DX, STRING_BUFFER
    CALL    PRINT
    JMP     MODIFY_ITEM_MENU_START
MODIFY_EXIT:
    RET
MODIFY_ITEM_MENU ENDP

; DELETE_ITEM_MENU
DELETE_ITEM_MENU PROC NEAR
DELETE_MENU_START:
    CALL    CLS
    LEA     DX, DELETE_ITEM_LOGO
    CALL    PRINT
    LEA     DX, ITEM_ID_PROMPT
    CALL    PRINT
    CALL    GET_CHAR_INPUT
    MOV     SELECTED_OPTION, AL
    CMP     SELECTED_OPTION, 30H
    JE      DELETE_MENU_END
; LOGIC TO DELETE

    JMP     DELETE_MENU_START

DELETE_MENU_END:
DELETE_ITEM_MENU ENDP

; VIEW_REPORT_MENU
STOCK_REPORT    PROC    NEAR
    LEA    DX, STOCK_REPORT_HEADER
    CALL    PRINT

        MOV     CX, 10                    ; Number of items to view
    ; MOV     SI, OFFSET ITEMS          ; Start address of the ITEMS array

VIEW_LOOP:
    ; Print Item Name
    LEA     DX, [SI]                  ; Load address of item name
    CALL    PRINT                      ; Print item name
    ; Print Item Quantity
    ADD     SI, 20                    ; Move to quantity (after name)
    LEA     DX, [SI]                  ; Load address of item quantity
    CALL    PRINT                      ; Print item quantity
    ; Print Item Unit Price
    ADD     SI, 4                     ; Move to unit price (after quantity)
    LEA     DX, [SI]                  ; Load address of unit price
    CALL    PRINT                      ; Print item unit price
    
    ; Move back to next item
    ADD     SI, 6                     ; Move to the next item's name
    LOOP    VIEW_LOOP                  ; Repeat for all items

    LEA    DX, STOCK_REPORT_FOOTER
    CALL    PRINT
    
    RET
STOCK_REPORT ENDP
;==============================================================================================
; ITEM - SPECIFIC FUNCTIONS
; GENERATE_ID
FORMAT_ID PROC NEAR
    ; Initialize CX to store the number
    MOV AL, ITEM_ID
    MOV CX, 10               ; Divide by 10 to extract each digit

    ; Start with the least significant digit and move backward
    MOV DI, OFFSET DIGITS    ; Point to the DIGITS buffer
    ADD DI, 3                ; Start at the least significant digit (4th position)

    ; Loop to extract each digit (4 digits total)
    MOV BX, 0                ; Initialize BX to zero
    MOV BL, AL               ; Move the number into BL for processing

    ; Extract least significant digits and store in DIGITS
    MOV AH, 0                ; Clear AH for DIV
    DIV CX                   ; Divide AL by 10, quotient in AL, remainder in AH
    ADD AH, '0'              ; Convert remainder (digit) to ASCII
    MOV [DI], AH             ; Store the digit in the DIGITS array
    DEC DI                   ; Move to the next digit position

    ; Repeat for next digit
    MOV AH, 0
    DIV CX
    ADD AH, '0'
    MOV [DI], AH
    DEC DI

    ; Repeat for next digit
    MOV AH, 0
    DIV CX
    ADD AH, '0'
    MOV [DI], AH
    DEC DI

    ; Store the last digit (the leading digit or zero)
    ADD AL, '0'
    MOV [DI], AL             ; Store the final digit (leading zero or number)
    ADD ITEM_ID, 1

    RET
FORMAT_ID ENDP

;==================================================================================================
; Function to store the temporary values into the array of items
; It assumes you want to store at the first position of the array (index 0)
STORE_ITEM PROC
    MOV SI, OFFSET DB_TEMP_NAME       ; Point to the temporary name buffer
    ; MOV DI, OFFSET ITEMS              ; Point to the first item in the ITEMS array

    ; Copy Name (20 bytes)
    MOV CX, 20                        ; Set count to 20 bytes for Name
    REP MOVSB                         ; Copy Name from DB_TEMP_NAME to ITEMS array

    ; Copy Quantity (4 bytes)
    MOV SI, OFFSET DB_TEMP_QUANTITY   ; Point to the temporary quantity buffer
    MOV CX, 4                         ; Set count to 4 bytes for Quantity
    REP MOVSB                         ; Copy Quantity from DB_TEMP_QUANTITY to ITEMS array

    ; Copy Unit Price (8 bytes)
    MOV SI, OFFSET DB_TEMP_UNITPRICE  ; Point to the temporary unit price buffer
    MOV CX, 8                         ; Set count to 8 bytes for Unit Price
    REP MOVSB                         ; Copy UnitPrice from DB_TEMP_UNITPRICE to ITEMS array

    RET
STORE_ITEM ENDP
; GENERAL PURPOSE FUNCTIONS
;==========================================================================================================
; Generalized procedure to copy a string from source to destination
; Parameters: 
;   SI = source address (string to copy from)
;   DI = destination address (string to copy to)
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
IS_DIGITS PROC NEAR
    ; Parameters:
    ;   SI = Address of the string (CONTAIN_STRING)
    
    MOV     SI, OFFSET CONTAIN_STRING1 ; Load address of the string

    MOV     AL, 0                  ; Assume no digits found (AL = 0)
    
CHECK_DIGIT_LOOP:
    MOV     BL, [SI]               ; Load current character from the string
    CMP     BL, '$'                ; Check for the string terminator
    JE      CHECK_DONE             ; If terminator, finish checking

    ; Check if the character is a digit
    CMP     BL, '0'                ; Check if character >= '0'
    JL      NOT_DIGIT              ; If less than '0', it's not a digit
    CMP     BL, '9'                ; Check if character <= '9'
    JG      NOT_DIGIT              ; If greater than '9', it's not a digit

    MOV     AL, 1                  ; Digit found, set AL to 1
    JMP     CHECK_DONE             ; Finish checking

NOT_DIGIT:
    INC     SI                     ; Move to the next character
    JMP     CHECK_DIGIT_LOOP       ; Repeat the loop

CHECK_DONE:
    RET
IS_DIGITS ENDP

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
    JGE H
    JMP Ten
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

AFTER_MANTISSA:
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

    ; Using my Contains function
    LEA     SI, UNIT_PRICE         ; Source string address
    LEA     DI, CONTAIN_STRING1     ; Destination string address
    CALL    COPY_STRING            ; General string copy

    MOV     CL, ','
    CALL    CONTAINS
    CMP     AL, 1
    JE      END_DOUBLE_VALUE
    
    MOV UNIT_PRICE[0], '0'

END_DOUBLE_VALUE:
    RET
DOUBLE_VALUE ENDP
;==========================================================================================================
; Got Contains (ASSUME CONTAIN_STRING Contains String, And CL contains Char)
CONTAINS PROC
    MOV     SI, 0                  ; Start index at 0

CHECK_CONTAIN_LOOP:
    MOV     AL, CONTAIN_STRING1[SI] ; Load current character from string
    CMP     AL, CL                 ; Compare with character to find
    JE      FOUND                  ; Jump if equal (found character)
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
CONTAINS ENDP
;==========================================================================================================
; STRLEN (ASSUME CONTAIN_STRING contain String)
StrLen PROC
    XOR     AL, AL                  ; Clear AL to store the length
    MOV     SI, 0                   ; Start index at 0
    XOR     CX, CX                  ; Clear CX, will use it for iteration

CountLoop:
    MOV     AL, CONTAIN_STRING1[SI]  ; DX + CX = Base Adress Location and the Index
    CMP     AL, '$'                 ; Check for the null terminator
    JE      Done                    ; If null terminator, we are done
    INC     CX                      ; Increment the count
    INC     SI
    JMP     CountLoop               ; Repeat the loop

Done:
    MOV     AL, CL                  ; Move the count to AL
    RET
StrLen ENDP

;==========================================================================================================
; Function to find the index of which a Char first appear (Assume CONTAIN_STRING have String, Assume ContainsChar have char), Return -1 if none
INDEX_OF PROC
    MOV     SI, 0                  ; Start index at 0
    MOV     CX, 0                  ; Initialize CX for the index

FIND_LOOP:
    MOV     AL, CONTAIN_STRING1[SI] ; Load current character from string
    CMP     AL, CL                 ; Compare with character to find
    JE      FOUND_OCCURENCE        ; Jump if equal (found character)

    CMP     AL, '$'                ; Check for string terminator
    JE      END_OF_STRING          ; Jump to not found if we reach terminator

    INC     SI                     ; Move to next character
    INC     CX                     ; Increment index
    JMP     FIND_LOOP              ; Repeat loop

END_OF_STRING:
    MOV     AL, -1                 ; Set AL to -1 (not found)
    RET

FOUND_OCCURENCE:
    MOV     AL, CL                 ; Set AL to the index (0-based)
    RET
INDEX_OF ENDP

;==========================================================================================================
; Assumes DS points to the data segment and that the strings are null-terminated.
; Parameters:
;   - SI: Address of the first string (STRING1)
;   - DI: Address of the second string (STRING2)
; Returns:

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
MOVEUPANDCLEAR PROC NEAR
    ; Move cursor up 2 lines
    MOV AH, 0H             ; Function to set cursor position
    MOV BH, 0              ; Page number (0 for the active page)
    MOV DH, 10             ; Row position (adjust as needed)
    MOV DL, 0              ; Column position (0 = first column)
    INT 10H                ; Call BIOS interrupt

    ; Clear current line
    LEA DX, CLS     ; Load address of clear line string
    MOV AH, 09H            ; DOS function to print string
    INT 21H                ; Call DOS interrupt

    RET                     ; Return from function
MOVEUPANDCLEAR ENDP

;==========================================================================================================
; Procedure to get String input
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

CLEAR_BUFFER PROC NEAR
    LEA DI, DB_TEMP_NAME  ; Assuming DB_TEMP_NAME is the buffer
    MOV CX, 20             ; Length of the buffer
    XOR AX, AX             ; Clear AX to 0
    REP STOSB              ; Fill the buffer with 0s
    RET
CLEAR_BUFFER ENDP

END MAIN