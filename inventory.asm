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
    InvalidChoice DB 'Invalid choice, please try again.', 0Dh, 0Ah, '$'

;-------------------------------------------------------------
.CODE
	MAIN	PROC	FAR
	
	MOV	AX , @DATA				; load data segment address to DS register
	MOV	DS , AX

	; google engineer level program code here
	CALL DisplayMenu             ; Call function to display menu
    CALL getUserInput            ; Get Input from user
    CALL HandleUserInput         ; Handle the user input

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

    ;-------------------------------------------------------------
    ; FUNCTION: GetUserInput
    ; PURPOSE:  Prints a null-terminated string to the console.
    ; INPUT:    The string's address should be loaded in DX.
    ;-------------------------------------------------------------

    GetUserInput PROC NEAR
        MOV AH, 01H                  ; DOS service to read a character
        INT 21H                      ; Interrupt to read the input
        MOV TEMP, AL                 ; Store the input character in TEMP
        RET
    GetUserInput ENDP

     ;-------------------------------------------------------------
    ; FUNCTION: HandleUserInput
    ; PURPOSE:  Checks the user input and performs actions based on the menu selection.
    ;-------------------------------------------------------------

    HandleUserInput PROC NEAR
        CMP TEMP, '1'                ; Compare input with '1'
        JE AddItem                   ; If '1', jump to AddItem

        CMP TEMP, '2'                ; Compare input with '2'
        JE RemoveItem                ; If '2', jump to RemoveItem

        CMP TEMP, '3'                ; Compare input with '3'
        JE ViewItems                 ; If '3', jump to ViewItems

        ; If none of the above, print invalid choice message
        LEA DX, InvalidChoice
        CALL PrintString
        CALL DisplayMenu             ; Re-display the menu
        CALL GetUserInput            ; Get input again
        CALL HandleUserInput          ; Handle the new input
        RET

    HandleUserInput ENDP

    ;-------------------------------------------------------------
    ; FUNCTION: AddItem
    ; PURPOSE:  Placeholder for adding an item to the inventory.
    ;-------------------------------------------------------------

    AddItem PROC NEAR
        ; Add your code to add an item here
        RET
    AddItem ENDP

    ;-------------------------------------------------------------
    ; FUNCTION: RemoveItem
    ; PURPOSE:  Placeholder for removing an item from the inventory.
    ;-------------------------------------------------------------

    RemoveItem PROC NEAR
        ; Add your code to remove an item here
        RET
    RemoveItem ENDP

    ;-------------------------------------------------------------
    ; FUNCTION: ViewItems
    ; PURPOSE:  Placeholder for viewing items in the inventory.
    ;-------------------------------------------------------------

    ViewItems PROC NEAR
        ; Add your code to view items here
        RET
    ViewItems ENDP


END	MAIN