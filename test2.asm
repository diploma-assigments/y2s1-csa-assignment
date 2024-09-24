.model small
.stack 100h
.data
    string1 DB 'Hello, ', '$'    ; First string (terminated by $)
    string2 DB 'World!', '$'     ; Second string (terminated by $)
    result DB 50 DUP('$')        ; Buffer for concatenated result, max 50 characters
.code
main:
    mov ax, @data                ; Initialize data segment
    mov ds, ax

    ; Copy first string into result buffer
    lea si, string1              ; Load address of string1
    lea di, result               ; Load address of result buffer
    call CopyString              ; Copy string1 to result

    ; Concatenate second string
    lea si, string2              ; Load address of string2
    call CopyString              ; Copy string2 to result (append)

    ; Manually append the '$' to terminate the concatenated result
    mov al, '$'
    stosb

    ; Display the concatenated result
    mov ah, 09h                  ; DOS print string function
    lea dx, result               ; Load address of result buffer
    int 21h                      ; Print the concatenated string

    ; Terminate the program
    mov ah, 4Ch                  ; DOS terminate program function
    int 21h

; Subroutine to copy string from SI to DI
CopyString PROC
    next_char:
        lodsb                    ; Load byte from SI into AL
        cmp al, '$'              ; Check if end of string ($)
        je done_copying           ; If yes, we're done
        stosb                    ; Store byte in DI (result buffer)
        jmp next_char            ; Repeat for next character
    done_copying:
        ret
CopyString ENDP

end main