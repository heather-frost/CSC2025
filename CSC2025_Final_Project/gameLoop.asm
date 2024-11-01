; Main Console program
; Spencer Medberry
; 1 November 2024
; gameLoop adapted from fibonacci counter

; Register usage:
;     EAX - readWrite procedure communication
;     EBX - integer user input result for term counting
;     ECX - helper register: char storage during ASCII conversion

.model flat

extern writeline: near
extern readline: near
extern charCount: near
extern writeNumber: near

.data

; both end with 0 to terminate the string
prompt              byte  "Opening gameLoop prompt: Enter a number between 1 and 45: ", 0
; beginning with 10 sends a line feed character before the text
gameLoopDialog     byte  10,"Starting with 1 and 2, the terms produced are: ",0
termSizeErrorMsg    byte  "Please enter a term between 1 and 45.",10,10,0
finalTerm           byte  10,10,"The value of term ",0
finalDialog         byte  "is "

.code

;; Call gameLoop() - No Parameters, no return value
gameLoop PROC near
_gameLoop:
    ; Display prompt for user input
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset prompt
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset prompt
    call  writeline

    ; ask console for user input
        ;; Call readline() - No Parameters, Returns ptr to buffer in eax
    call  readline
    ; user input stored in eax
    
    ;convert user input from ASCII to integer
    mov   ecx,0
    mov   ebx,0
ASCIIloop:
    mov  cl,[eax]                   ; Look at the character in the string
    cmp  ecx,13                     ; check for carriage return.
    je numberGet
    cmp  ecx,10                     ; check for line feed.
    je numberGet
    cmp  ecx,0                      ; check for end of string.
    je numberGet
    sub  cl,'0'
    imul ebx,10
    add  ebx,ecx
    inc  eax                        ; go to next letter
    jmp  ASCIIloop
numberGet:
    cmp ebx,45
    jg termSizeError
    cmp ebx,1
    jl termSizeError
    push ebx
    

    ; Print gameLoopDialog
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset gameLoopDialog
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset gameLoopDialog
    call  writeline

    ;prep registers for addloop
    pop ebx
    mov   eax, 2
    mov   ecx, 1
    push ebx

    ;addloop adds eax and ecx to get the next term in the fib. sequence and also prints it to the console
addloop:
    ;add function
    push  eax
    add   eax, ecx
    pop   ecx

    ;store registers
    push  eax
    push  ecx
    push  ebx

    ;writeNumber
        ;; Call writeNumber(number) - print the ASCII value of a number.
        ;; Parameter: number is number to be converted to Ascii and printed.
        ;; Returns nothing
    push  eax
    call  writeNumber

    ;retrieve registers
    pop   ebx
    pop   ecx
    pop   eax

    ;loopy bit
    dec ebx
    cmp ebx,0
    jg  addloop
;End addloop

;Ending dialog
    pop ebx
    push eax    ;2nd writeNumber parameter
    push ebx    ;1st writeNumber parameter
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset finalTerm
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset finalTerm
    call  writeline
        ;; Call writeNumber(number) - print the ASCII value of a number.
        ;; Parameter: number is number to be converted to Ascii and printed.
        ;; Returns nothing
    call  writeNumber
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset finalDialog
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset finalDialog
    call  writeline
        ;; Call writeNumber(number) - print the ASCII value of a number.
        ;; Parameter: number is number to be converted to Ascii and printed.
        ;; Returns nothing
    call  writeNumber


exit:
    ret     ; Return to the main program.

termSizeError:
    ; Print termSizeErrorMsg
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset termSizeErrorMsg
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset termSizeErrorMsg
    call  writeline
    jmp _gameLoop
; End termSizeError
    
gameLoop ENDP
END