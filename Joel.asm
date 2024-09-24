TITLE ITEM MENU

.MODEL SMALL                 ; Declare small memory model
.STACK 64                    ; Declare stack segment
.DATA

    DB_TEMP				DB      ?         ; Temporary data (could be for username/password)
    DW_TEMP				DW      ?

    WHOLE_NUM           DW      12345
    TEN_THOUSAND        DW      10000
    THOUSAND            DW      1000
    HUNDRED             DW      100
    TEN                 DW      10

    UNIT_PRICE              DB      "123456", '$'  ; String to check for comma
    CONTAIN_STRING          DB      "xxxxxx", '$'

	x EQU 4 ; No. of Attributes in Item
	y EQU 20 ; No. Of Items
	
	ITEM_ARRAY DB x * y DUP(?) ; Allocate space for the 2D array

    CRLF                    EQU     0DH, 0AH 
	LongLine				DB  	"---------------------------------------------", CRLF, "$"


    LENGTH_OF_UNIT_PRICE    EQU     7  ; Length of "123,456"
    COMMA_FOUND_MSG         DB      "Comma found at index: ", '$'
    NO_COMMA_FOUND_MSG      DB      "No comma found in UNIT_PRICE.", '$'

    ITEMMENU_OPTIONS		DB  	"1 - Add Item", CRLF, "2 - Modify item", CRLF, "3 - Delete item", CRLF, "0 - Exit", CRLF, "$"
	ITEMMODIFYMENU			DB  	"1 - Modify Name", CRLF,"2 - Modify Quantity", CRLF,"3 - Modify UnitPrice", CRLF, "0 - Exit", CRLF, "$"
	STOCK_REPORT_HEADER     DB      "---------------------------------------------", CRLF
                        	DB      "| ITEM ID | Name        | Count | UnitPrice |", CRLF, "$"
	STOCK_EACH				DB		"|         |             |       |           |", CRLF, "$"					;9, 13, 6, 11

.CODE

MAIN PROC FAR
    MOV     AX, @DATA              ; Load data segment address to AX
    MOV     DS, AX                 ; Initialize data segment

    CALL DOUBLE_VALUE

    LEA     DX, UNIT_PRICE
    CALL    PRINT

    ; Exit the program
    MOV     AX, 4C00H              ; Terminate program
    INT     21H
MAIN ENDP
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
    LEA     DI, CONTAIN_STRING     ; Destination string address
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

CHECK_LOOP:
    MOV     AL, CONTAIN_STRING[SI] ; Load current character from string
    CMP     AL, CL                 ; Compare with character to find
    JE      FOUND                  ; Jump if equal (found character)
    CMP     AL, '$'                ; Check for string terminator
    JE      NOT_FOUND              ; Jump to not found if we reach terminator

    INC     SI                     ; Move to next character
    JMP     CHECK_LOOP             ; Repeat loop

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
; STRLEN (ASSUME DX contain String)
StrLen PROC
    XOR     AL, AL                  ; Clear AL to store the length
    MOV     SI, 0                   ; Start index at 0
    XOR     CX, CX                  ; Clear CX, will use it for iteration

CountLoop:
    MOV     AL, CONTAIN_STRING[SI]  ; DX + CX = Base Adress Location and the Index
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
; Function to find the index of which a Char first appear (Assume DX have String, Assume ContainsChar have char), Return -1 if none
INDEX_OF PROC
    MOV     SI, 0                  ; Start index at 0
    MOV     CX, 0                  ; Initialize CX for the index

FIND_LOOP:
    MOV     AL, CONTAIN_STRING[SI] ; Load current character from string
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
; Procedure to print string (assumes DX holds address of string)
PRINT PROC NEAR
    MOV     AH, 09H                ; Function 09H: Print string to stdout
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

END MAIN