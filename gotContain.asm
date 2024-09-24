TITLE Check Comma in UNIT_PRICE

.MODEL SMALL                 ; Declare small memory model
.STACK 64                    ; Declare stack segment
.DATA

    UNIT_PRICE DB "123,456", '$'  ; String to check for comma
    LENGTH_OF_UNIT_PRICE EQU 7      ; Length of "123,456"

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
; Function to check for comma in UNIT_PRICE
CONTAINS PROC
    MOV     SI, 0                  ; Start index at 0
    MOV     CX, LENGTH_OF_UNIT_PRICE ; Length of UNIT_PRICE string (excluding '$')

CHECK_LOOP:
    MOV     AL, UNIT_PRICE[SI]     ; Load current character from UNIT_PRICE
    CMP     AL, ','                 ; Compare with ',' character
    JE      FOUND             ; Jump if equal (found comma)

    CMP     AL, '$'                 ; Check for string terminator
    JE      FOUND          ; Jump to not found if we reach terminator

    INC     SI                      ; Move to next character
    LOOP    CHECK_LOOP              ; Repeat until CX is 0

FOUND:
    ; If no comma found, set AL to 0 (false)
    XOR     AL, AL                  ; Set AL to 0 (false)
    RET

FOUND:
    ; If comma is found, set AL to 1 (true)
    MOV     AL, 1                   ; Set AL to 1 (true)
    RET
CONTAINS ENDP

;==========================================================================================================
; Procedure to print string (assumes DX holds address of string)
PRINT PROC NEAR
    MOV     AH, 09H                ; Function 09H: Print string to stdout
    INT     21H
    RET
PRINT ENDP

END MAIN