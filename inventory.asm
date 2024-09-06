TITLE	INVENTORY SYSTEM

.MODEL	SMALL				; declare small memory model
.STACK	64				; declare stack segment
.DATA
	TEMP	DB	?

;-------------------------------------------------------------
.CODE
	MAIN	PROC	FAR
	
	MOV	AX , @DATA				; load data segment address to DS register
	MOV	DS , AX

	; google engineer level program code here

	MOV	AX , 4C00H				; request for program proper exit
	INT	21H

	MAIN	ENDP					; end of main function
END	MAIN