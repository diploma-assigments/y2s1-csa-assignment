TITLE	INVENTORY SYSTEM

.MODEL	SMALL				; declare small memory model
.STACK	64				; declare stack segment
.DATA
	TEMP	DB	?

	; Sample menu options
    MenuOption1 DB '1. Add Item', 0Dh, 0Ah, '$'   ; Menu Option 1
    MenuOption2 DB '2. Remove Item', 0Dh, 0Ah, '$' ; Menu Option 2
    MenuOption3 DB '3. View Items', 0Dh, 0Ah, '$' ; Menu Option 3
    MenuPrompt  DB 'Enter your choice: ', '$'

;-------------------------------------------------------------
.CODE
	MAIN	PROC	FAR
	
	MOV	AX , @DATA				; load data segment address to DS register
	MOV	DS , AX

	; google engineer level program code here
	CALL DisplayMenu             ; Call function to display menu

	MOV	AX , 4C00H				; request for program proper exit
	INT	21H

	MAIN	ENDP					; end of main function

	; Add any functions here

	;-------------------------------------------------------------
    ; FUNCTION: DisplayMenu
    ; PURPOSE:  Prints multiple menu options stored in memory.
    ; USAGE:    Add more menu options by calling print inside the function.
    ;-------------------------------------------------------------

    DisplayMenu PROC NEAR

        ; Print menu options
        LEA DX, MenuOption1          ; Load the address of the first option
        CALL PrintString             ; Print the first option

        LEA DX, MenuOption2          ; Load the address of the second option
        CALL PrintString             ; Print the second option

        LEA DX, MenuOption3          ; Load the address of the third option
        CALL PrintString             ; Print the third option

        ; Print input prompt
        LEA DX, MenuPrompt           ; Load the prompt address
        CALL PrintString

        RET
    DisplayMenu ENDP

    ;-------------------------------------------------------------
    ; FUNCTION: PrintString
    ; PURPOSE:  Prints a null-terminated string to the console.
    ; INPUT:    The string's address should be loaded in DX.
    ;-------------------------------------------------------------

    PrintString PROC NEAR
        MOV AH, 09H                  ; DOS service to print string
        INT 21H                      ; Interrupt to print the string
        RET
    PrintString ENDP

END	MAIN