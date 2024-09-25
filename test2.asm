.model small
.stack 100h
.data
    ARRAY db 21 dup("$")    ; Array to hold the input string (20 characters + null terminator)
    prompt db "Enter string (max 20 characters): $"
    outputMsg db "You entered: $"
.code
main:
    mov ax, @data
    mov ds, ax

    ; Prompt the user for input
    mov dx, offset prompt
    mov ah, 09h
    int 21h

    ; Call the input function
    call GetStringInput

    ; Print the output message
    mov dx, offset outputMsg
    mov ah, 09h
    int 21h

    ; Print the entered string
    mov dx, offset ARRAY
    mov ah, 09h
    int 21h

    ; Exit the program
    mov ax, 4C00h
    int 21h

; Function: GetStringInput
; Input: None
; Output: Stores the string in ARRAY
GetStringInput proc
    mov si, 0                ; Initialize index for ARRAY
    mov di, offset ARRAY     ; Pointer to ARRAY

read_input:
    ; Read a character
    mov ah, 01h              ; Function to read a character
    int 21h                  ; BIOS interrupt to read a character

    cmp al, 13               ; Check if the character is Enter (carriage return)
    je done                  ; If yes, finish input

    ; Store the character in the array if less than 20 characters
    cmp si, 20               ; Check if the input limit has been reached
    je done                  ; If yes, finish input
    mov [di], al             ; Store the character in ARRAY
    inc si                   ; Increment the index
    inc di                   ; Move to the next position in ARRAY
    jmp read_input           ; Continue reading input

done:
    ; Null-terminate the string
    mov byte ptr [di], '$'   ; Ensure the string is null-terminated
    ret
GetStringInput endp
end main