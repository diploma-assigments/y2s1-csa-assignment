.model SMALL
.stack 100h
.Data
    fname   db  'output.txt', 0
    fhandle dw  ?

.CODE

    main PROC
        mov  ax, @DATA
        mov  ds, ax

        ;create a new file
        mov  ah, 3Ch
        lea  dx, fname
        mov  cl, 0
        int  21h
        mov  fhandle, ax
        
        ;close a file
        mov  ah, 3Eh
        mov  bx, fhandle
        int  21h

        ;exit
        mov  ah, 4Ch
        int  21h
        main ENDP
    end main