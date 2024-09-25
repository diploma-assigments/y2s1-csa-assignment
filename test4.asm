.model small
.stack 100h
.data
    buffer db 20               ; Maximum input length
    buffer_length db 0         ; Actual number of characters read
    buffer_input db 21 dup('$') ; Input buffer (first byte is length, rest are chars)
    prompt db 'Enter input: $'
    newline db 0Dh, 0Ah, '$'

.code
main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Display prompt
    mov ah, 09h                ; Function to display string
    lea dx, prompt
    int 21h

    ; Get string input
    lea dx, buffer_input        ; Load address of input buffer
    mov ah, 0Ah                 ; Buffered input function (reads into buffer_input)
    int 21h                     ; Call interrupt 21h to get input

    ; Move the number of characters entered from buffer_input+1 to buffer_length
    mov al, [buffer_input + 1]  ; Number of characters entered is at buffer_input + 1
    mov [buffer_length], al     ; Store the actual number of characters in buffer_length

    ; Process the input characters
    lea si, buffer_input + 2    ; Load address of the first character of input (starts at buffer_input + 2)
    mov cl, [buffer_length]     ; Get the number of characters entered by user
    xor di, di                  ; Clear DI (index for final input)

process_input:
    cmp di, 20              ; Check if input length has reached the maximum
    jge finish_processing    ; If DI >= 20, jump to finish processing
    mov al, [si]            ; Load character from buffer
    cmp al, 0               ; Check for null terminator
    je finish_processing     ; If end of string, finish processing
    cmp al, 8               ; Check if character is backspace
    je handle_backspace      ; If backspace, handle it
    mov [buffer_input + di], al ; Store character in the final position
    inc di                  ; Move to next position in final string
    inc si                  ; Move to next character in input buffer
    jmp process_input       ; Repeat for all characters
handle_backspace:
    cmp di, 0                   ; Check if there's anything to delete
    je process_input            ; If nothing to delete, continue
    dec di                      ; Move back to the last character
    mov [buffer_input + di], '$' ; Replace the last character with '$' or clear it
    jmp process_input           ; Continue processing

finish_processing:
    mov [buffer_input + di], '$' ; Null-terminate the string
    ; Print the resulting string
    mov ah, 09h                 ; Function to display string
    lea dx, newline
    int 21h                     ; Print newline
    lea dx, buffer_input         ; Load the buffer to print
    int 21h                     ; Display final processed string

    ; Exit program
    mov ax, 4C00h
    int 21h
main ENDP
END main