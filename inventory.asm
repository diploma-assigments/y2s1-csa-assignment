TITLE INVENTORY SYSTEM
	
.MODEL SMALL                 ; declare small memory model
.STACK 64                    ; declare stack segment
.DATA
	DB_TEMP				DB		?
	DW_TEMP				DW		?

	CRLF				EQU		0DH, 0AH 
	
	MAINMENU_OPTIONS	DB	"1 - Staff Log In", CRLF, "2 - Staff Sign Up", CRLF, "0 - Exit", CRLF, "$"
	
	

;==========================================================================================================
.CODE

	MAIN 	PROC	FAR
	
	MOV		AX , @DATA                	; load data segment address to DS register
	MOV		DS , AX
	
	CALL	CLS

	LEA		DX , MAINMENU_OPTIONS		; print main menu options
	CALL	PRINT

	
	MOV 	AX, 4C00H                	; request for program proper exit
	INT 	21H
	
	MAIN 	ENDP                    	; end of main function


	;======================================================================================================
	PRINT	PROC 	NEAR
	MOV		AH , 09H
	INT		21H
	RET
	PRINT	ENDP
	
	;======================================================================================================
    ; clear screen
	CLS		PROC 	NEAR
    MOV     AX, 0600H            ; function 06H - Scroll up (clear screen)
    MOV     BH, 07H              ; attribute (07H = light gray on black background)
    MOV     CX, 0000H            ; upper-left corner (row 0, column 0)
    MOV     DX, 184FH            ; lower-right corner (row 24, column 79)
    INT     10H                  ; call BIOS video interrupt
	; reset cursor to (0, 0)
	MOV     AH, 02H              ; function 02H - Set cursor position
    MOV     BH, 00H              ; page number (0 = first page)
    MOV     DH, 00H              ; row (0 = top row)
    MOV     DL, 00H              ; column (0 = left column)
    INT     10H                  ; call BIOS video interrupt

	RET
	CLS		ENDP


;==========================================================================================================
END	MAIN