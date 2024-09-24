TITLE Check Comma in UNIT_PRICE

.MODEL SMALL                 ; Declare small memory model
.STACK 64                    ; Declare stack segment
.DATA

    UNIT_PRICE DB "123,456", '$'  ; String to check for comma
    LENGTH_OF_UNIT_PRICE EQU 7  ; Length of "123,456"
    COMMA_FOUND_MSG DB "Comma found at index: ", '$'
    NO_COMMA_FOUND_MSG DB "No comma found in UNIT_PRICE.", '$'

.CODE

MAIN PROC FAR
    MOV     AX, @DATA              ; Load data segment address to AX
    MOV     DS, AX                 ; Initialize data segment

    CALL CHECK_COMMA               ; Call the procedure to check for comma

    ; Exit the program
    MOV     AX, 4C00H              ; Terminate program
    INT     21H
MAIN ENDP

;==========================================================================================================
; Procedure to check for comma in UNIT_PRICE
CHECK_COMMA PROC
    MOV     SI, 0                  ; Start index at 0
    MOV     CX, LENGTH_OF_UNIT_PRICE ; Length of UNIT_PRICE string (excluding '$')

CHECK_LOOP:
    MOV     AL, UNIT_PRICE[SI]     ; Load current character from UNIT_PRICE
    CMP     AL, ','                 ; Compare with ',' character
    JE      COMMA_FOUND             ; Jump if equal (found comma)

    CMP     AL, '$'                 ; Check for string terminator
    JE      NO_COMMA_FOUND          ; Jump to not found if we reach terminator

    INC     SI                      ; Move to next character
    LOOP    CHECK_LOOP              ; Repeat until CX is 0

NO_COMMA_FOUND:
    ; Handle the case where comma was not found
    LEA     DX, NO_COMMA_FOUND_MSG  ; Load address of no comma message
    CALL    PRINT                   ; Print no comma message
    RET

COMMA_FOUND:
    ; Handle the case where comma was found
    MOV     BX, SI                  ; Save the index of the found comma
    CALL PRINT_COMMA_INDEX          ; Call the function to print the index
    RET
CHECK_COMMA ENDP

;==========================================================================================================
; Procedure to print the index of the comma found
PRINT_COMMA_INDEX PROC
    ; Prepare to print the found message first
    LEA     DX, COMMA_FOUND_MSG     ; Load address of found message
    CALL    PRINT                   ; Print found message

    ; Convert the index in BX to ASCII for printing
    MOV     AX, BX                  ; Load the index into AX
    ADD     AX, 30H                 ; Convert number to ASCII character

    ; Print the index character
    MOV     DL, AL                  ; Move the ASCII character to DL
    MOV     AH, 02H                 ; Function 02H: Print character
    INT     21H                     ; Call DOS interrupt

    RET
PRINT_COMMA_INDEX ENDP

;==========================================================================================================
; Procedure to print string (assumes DX holds address of string)
PRINT PROC NEAR
    MOV     AH, 09H                ; Function 09H: Print string to stdout
    INT     21H
    RET
PRINT ENDP

END MAIN