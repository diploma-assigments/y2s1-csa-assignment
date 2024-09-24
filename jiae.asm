.MODEL SMALL
.STACK 64
.DATA
    FILENAME        DB "staff.txt", 0   ; File name (null-terminated)
    DATA_TO_WRITE   DB "abc"            ; Data to write to file
    FILE_HANDLE     DW ?                ; File handle

.CODE
MAIN PROC
    ; Set up data segment
    MOV AX, @DATA
    MOV DS, AX

    ; write to file "staff.txt"
    MOV AH, 40h             ; DOS function to create a file
    MOV CX, 0               ; File attributes (normal)
    LEA DX, FILENAME        ; Load the file name
    INT 21h                 ; DOS interrupt to create the file
    JC ERROR                ; Jump if there's an error
    MOV FILE_HANDLE, AX     ; Store the file handle

    ; Write "abc" to the file
    MOV AH, 40h             ; DOS function to write to file
    MOV BX, FILE_HANDLE     ; File handle
    LEA DX, DATA_TO_WRITE   ; Load the address of the data
    MOV CX, 3               ; Number of bytes to write
    INT 21h                 ; DOS interrupt to write
    JC ERROR                ; Jump if there's an error

    ; Close the file
    MOV AH, 3Eh             ; DOS function to close file
    MOV BX, FILE_HANDLE     ; File handle
    INT 21h                 ; DOS interrupt to close the file
    JC ERROR                ; Jump if there's an error

    ; Exit the program
    MOV AX, 4C00h
    INT 21h

ERROR:
    ; Exit with error code
    MOV AX, 4C01h
    INT 21h

MAIN ENDP
END MAIN
