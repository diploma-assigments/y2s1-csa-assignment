.model small
.stack 100h
.data
    ARRAY db 21 dup("$")    ; Array to hold the input string (20 characters + null terminator)
    prompt db "Enter string (max 20 characters): $"
    outputMsg db "You entered: $"
    errorMsg db "Invalid input! Only alphabet characters are allowed.$"
.code
MAIN PROC FAR
    mov ax, @data
    mov ds, ax

read_input_loop:
    ; Prompt the user for input
    mov dx, offset prompt
    mov ah, 09h
    int 21h

    ; Call the input function
    call GetStringInput

    ; Validate the input
    mov si, 0                ; Reset index for ARRAY
    mov di, offset ARRAY     ; Pointer to ARRAY
    mov cx, 20               ; Maximum length to check

validate_input:
    mov al, [di]             ; Load the character from ARRAY
    cmp al, '$'              ; Check for null terminator
    je valid_input           ; If null terminator, input is valid
    call Is_Digit            ; Check if the character is a digit
    cmp al, 0                ; Check the result
    je invalid_input         ; If true, input is invalid
    call Is_Not_Alphabet     ; Check if the character is not an alphabet
    cmp al, 0                ; Check the result
    je invalid_input         ; If true, input is invalid

    inc si                   ; Move to the next character
    inc di                   ; Move to the next position in ARRAY
    loop validate_input      ; Repeat for all characters

valid_input:
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

invalid_input:
    ; Clear the screen (using DOS interrupt)
    mov ah, 0
    int 10h
    mov ah, 0
    int 10h   ; Clear the screen
    jmp read_input_loop        ; Reprompt for input
MAIN ENDP

; Function: GetStringInput
; Input: None
; Output: Stores the string in ARRAY
GetStringInput proc NEAR
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

; Function: Is_Digit
; Input: AL - character to check
; Output: AL - 1 if digit, 0 otherwise
Is_Digit proc NEAR
    cmp al, '0'              ; Compare with ASCII '0'
    jb not_digit             ; If less, not a digit
    cmp al, '9'              ; Compare with ASCII '9'
    ja not_digit             ; If greater, not a digit
    mov al, 1                 ; Set AL to 1 (true)
    ret

not_digit:
    xor al, al               ; Set AL to 0 (false)
    ret
Is_Digit endp

; Function: Is_Not_Alphabet
; Input: AL - character to check
; Output: AL - 1 if not an alphabet, 0 if it is an alphabet
Is_Not_Alphabet proc NEAR

    cmp al, 'A'              ; Compare with ASCII 'A'
    jb not_alpha             ; If less, not an alphabet
    cmp al, 'Z'              ; Compare with ASCII 'Z'
    jbe is_alpha             ; If between 'A' and 'Z', it's an alphabet
    cmp al, 'a'              ; Compare with ASCII 'a'
    jb not_alpha             ; If less, not an alphabet
    cmp al, 'z'              ; Compare with ASCII 'z'
    ja not_alpha             ; If greater, not an alphabet
is_alpha:
    mov al, 1               ; Set AL to 0 (true)
    ret

not_alpha:
    mov al, 0                 ; Set AL to 1 (false)
    ret
Is_Not_Alphabet endp

end MAIN