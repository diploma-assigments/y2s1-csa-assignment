TITLE ITEM MENU

.MODEL SMALL                 ; Declare small memory model
.STACK 64                    ; Declare stack segment
.DATA

    DW_TEMP				DW      ?

    DB_TEMP_NAME             DB      20 DUP(0) ; Temporary data for username/password (20 bytes max)
    DB_TEMP_QUANTITY         DB      4 DUP(0) ; Separate storage for password
    DB_TEMP_UNITPRICE        DB      8 DUP(0)


    WHOLE_NUM           DW      12345
    TEN_THOUSAND        DW      10000
    THOUSAND            DW      1000
    HUNDRED             DW      100
    TEN                 DW      10

    UNIT_PRICE              DB      "123456", '$'  ; String to check for comma
    CONTAIN_STRING1          DB      21 DUP('$')
    CONTAIN_STRING2         DB      21 DUP('$')
    COMPARE_STRING1          DB      21 DUP('$')
    COMPARE_STRING2         DB      21 DUP('$')
    STRING_BUFFER DB 21 DUP(0) ; Allocate space for the string (20 chars + 1 for null terminator)

	x EQU 4 ; No. of Attributes in Item
	y EQU 20 ; No. Of Items
	
	ITEM_ARRAY DB x * y DUP(?) ; Allocate space for the 2D array

    ARRAY db 20,?,8 dup ("$")

    CRLF                    EQU     0DH, 0AH
    ZERO                    DB     "0", '$'
	LONGLINE				DB  	"---------------------------------------------", CRLF, "$"

    SELECTED_OPTION         DB      ?         ; Store selected option
    PROMPT_MSG              DB      CRLF, "Select an option: ", '$'
    SALES_COUNT             DB      10, 20, 30 ; Example of data

    LENGTH_OF_UNIT_PRICE    EQU     7  ; Length of "123,456"
    COMMA_FOUND_MSG         DB      "Comma found at index: ", '$'
    NO_COMMA_FOUND_MSG      DB      "No comma found in UNIT_PRICE.", '$'

    ; ITEM_MENU OPTIONS
    ITEM_MENU_LOGO          DB      "---------------------------------------------",CRLF
                            DB      "|                ITEM MENU                  |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'
    ITEMMENU_OPTIONS		DB  	"1 - Add Item", CRLF, "2 - Modify item", CRLF, "3 - Delete item", CRLF,"4 - View stock report", CRLF, "5 - View trending item report", CRLF,"0 - Exit", CRLF, "$"

    ; ADD ITEM
    ADD_ITEM_LOGO           DB      "---------------------------------------------",CRLF
                            DB      "|              ADD ITEM MENU                |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'

    ITEM_NAME_PROMPT        DB      CRLF,"Enter ITEM Name      : $"
    ITEM_UNITPRICE_PROMPT   DB      CRLF,"Enter ITEM Unit Price: $"
    ITEM_QUANTITY_PROMPT    DB      CRLF,"Enter ITEM Quantity  : $"

    ; MODIFY MENU
    MODIFY_ITEM_LOGO        DB      "---------------------------------------------",CRLF
                            DB      "|             MODIFY ITEM MENU              |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'
	ITEMMODIFY_OPTIONS		DB  	"1 - Modify Name", CRLF,"2 - Modify Quantity", CRLF,"3 - Modify UnitPrice", CRLF, "0 - Exit", CRLF, "$"

    ; DELETE MENU
    DELETE_ITEM_LOGO        DB      "---------------------------------------------",CRLF
                            DB      "|             DELETE ITEM MENU              |",CRLF
                            DB      "---------------------------------------------",CRLF, '$'

    ITEM_ID_PROMPT          DB      CRLF,"Enter ITEM Name      : $"

    ; STOCK_REPORT
	STOCK_REPORT_HEADER     DB      "-------------------------------------------------------", CRLF
                        	DB      "| ITEM ID | Name        | Count | UnitPrice |  Worth  |", CRLF
                            DB      "-------------------------------------------------------", CRLF, '$'
	STOCK_EACH				DB		"|         |             |       |           |         |", CRLF, '$'		;9, 13, 6, 11,7
    STOCK_REPORT_FOOTER     DB      "-------------------------------------------------------", CRLF
                    		DB		"|                        Total Stock Worth: |         |", CRLF
                            DB      "-------------------------------------------------------", CRLF, '$'          ;42, 7

    ; Trending sale report
    TRENDING_REPORT_HEADER  DB      "-------------------------------------------------------", CRLF
                            DB      "| ITEM ID | Name        | Sold Count | UnitPrice |  Worth  |", CRLF
                            DB      "-------------------------------------------------------", CRLF, '$'
    TRENDING_EACH           DB      "|         |             |            |           |         |", CRLF, '$'
    TRENDING_REPORT_FOOTER  DB      "-------------------------------------------------------", CRLF
                            DB      "|                         Total Sales Worth: |         |", CRLF
                            DB      "-------------------------------------------------------", CRLF, '$'

    TESTSTR1    DB  "Test",'$'
    TESTSTR2    DB  "Test",'$'
.CODE

MAIN PROC FAR
    MOV     AX, @DATA              ; Load data segment address to AX
    MOV     DS, AX                 ; Initialize data segment

    ; CALL DOUBLE_VALUE

    ; LEA     DX, UNIT_PRICE
    ; CALL    PRINT
; MAIN_START:
    CALL    ITEM_MENU

    MOV     BX, OFFSET CONTAIN_STRING1 ; Pass the address of the storage
    CALL    GET_STRING                 ; Call the GET_STRING procedure

    ; Optional: Print the entered string
    MOV     DX, OFFSET CONTAIN_STRING1  ; Load address of the string
    CALL    PRINT                       ; Print the string

    ; Exit the program
    MOV     AX, 4C00H              ; Terminate program
    INT     21H
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
    CALL    GET_INPUT
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
    CALL    STOCK_REPORT_MENU
    JMP     ITEM_MENU_START
ITEM_MENU_OPTION5:
    CALL    TRENDING_REPORT_MENU
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
    LEA     DX, DB_TEMP_NAME
    CALL    PRINT

;------
    ; CALL    CLEAR_PROMPT

    ; JMP     ITEM_PROMPT1
ITEM_PROMPT2:
    LEA     DX, ITEM_QUANTITY_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING
    LEA     DX, STRING_BUFFER
    CALL    PRINT

ITEM_PROMPT3:
    LEA     DX, ITEM_UNITPRICE_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING
    LEA     DX, STRING_BUFFER
    CALL    PRINT

ADD_ITEM_EXIT:
    RET
ADD_ITEM_MENU ENDP

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
    CALL    GET_INPUT
    MOV     SELECTED_OPTION, AL
    CMP     SELECTED_OPTION, 30H
    JE      MODIFY_EXIT
    CMP     SELECTED_OPTION, 31H
    JE      MODIFY_NAME
    CMP     SELECTED_OPTION, 32H
    JE      MODIFY_QUANTITY
    CMP     SELECTED_OPTION, 33H
    JE      MODIFY_UNITPRICE

MODIFY_NAME:
    LEA     DX, ITEM_NAME_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING
    LEA     DX, STRING_BUFFER
    CALL    PRINT
    JMP     MODIFY_ITEM_MENU_START
MODIFY_QUANTITY:
    LEA     DX, ITEM_QUANTITY_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING
    LEA     DX, STRING_BUFFER
    CALL    PRINT
    JMP     MODIFY_ITEM_MENU_START
MODIFY_UNITPRICE:
    LEA     DX, ITEM_UNITPRICE_PROMPT
    CALL    PRINT
    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING
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

    MOV     BX, OFFSET STRING_BUFFER
    CALL    GET_STRING
    LEA     DX, STRING_BUFFER
    CALL    PRINT
    JMP     DELETE_MENU_START
    RET
DELETE_ITEM_MENU ENDP

; VIEW_REPORT_MENU
STOCK_REPORT    PROC    NEAR
    LEA    DX, STOCK_REPORT_HEADER
    CALL    PRINT

    LEA    DX, STOCK_REPORT_FOOTER
    CALL    PRINT
    
    RET
STOCK_REPORT ENDP

; ITEM - SPECIFIC FUNCTIONS
; GENERATE_ID

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
CLEAR_PROMPT PROC NEAR
; Clear left until prompt message
    MOV     AH, 02H                 ; Function to set cursor position
    MOV     DL, 0                    ; Row (current row)
    MOV     DH, 0                    ; Column (leftmost position)
    INT     10H                      ; Set cursor position

    MOV     AH, 02H                     ; Function to set cursor position
    MOV     DL, 0                        ; Row (0 for top of the screen)
    MOV     DH, 0                        ; Column (0 for leftmost)
    INT     10H                          ; Set cursor position

    RET
CLEAR_PROMPT ENDP

;==========================================================================================================
; Procedure to get user input (single character)
GET_INPUT PROC NEAR
    MOV     AH, 01H                      ; function 01H: Read single character from stdin
    INT     21H                          ; store input in AL
    RET
GET_INPUT ENDP

;==========================================================================================================
; Procedure to get String input
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
; Procedure to get an alphabetic string from user input (up to 20 characters)
GET_ALPHA_STRING PROC NEAR
    MOV     CX, 20                       ; max length
    MOV     DI, BX                       ; DI points to the destination (string)
    
GET_ALPHA_LOOP:
    CALL    GET_INPUT                    ; Get a single character
    CMP     AL, 0DH                      ; Check if Enter key (carriage return) is pressed
    JE      END_GET_ALPHA                ; If yes, end the input loop

    ; Check if the input is an alphabetic character (A-Z, a-z)
    CMP     AL, 'A'                      ; Compare with 'A'
    JL      GET_ALPHA_LOOP               ; If less than 'A', ignore input
    CMP     AL, 'Z'                      ; Compare with 'Z'
    JG      CHECK_LOWERCASE              ; If greater than 'Z', check lowercase

    ; Store uppercase letter
    STOSB
    DEC     CX                           ; Decrease length counter
    JMP     CHECK_LENGTH                 ; Check if length exceeded

CHECK_LOWERCASE:
    CMP     AL, 'a'                      ; Compare with 'a'
    JL      GET_ALPHA_LOOP               ; If less than 'a', ignore input
    CMP     AL, 'z'                      ; Compare with 'z'
    JG      GET_ALPHA_LOOP               ; If greater than 'z', ignore input

    ; Store lowercase letter
    STOSB
    DEC     CX                           ; Decrease length counter

CHECK_LENGTH:
    CMP     CX, 0                        ; Check if max length is reached
    JZ      END_GET_ALPHA                ; End if max length reached
    JMP     GET_ALPHA_LOOP               ; Loop until done

END_GET_ALPHA:
    MOV     BYTE PTR [DI], 0             ; Null-terminate the string
    RET
GET_ALPHA_STRING ENDP

;==========================================================================================================
; Procedure to print string (assumes DX holds address of string)
PRINT PROC NEAR
    MOV     AH, 09H                ; Function 09H: Print string to stdout
    INT     21H
    RET
PRINT ENDP

;==========================================================================================================
; Procedure to print a character stored in AL
PRINT_CHAR PROC NEAR
    MOV     AH, 02H              ; Function 02H: Display character
    INT     21H                  ; Call DOS interrupt
    RET
PRINT_CHAR ENDP
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


    ; Code to finalize report (print total worth, etc.)
; STOCK_REPORT PROC
STOCK_REPORT_MENU PROC NEAR
 
STOCK_REPORT_MENU ENDP

;==========================================================================================================
; Write to file (Function 40h)

END MAIN
