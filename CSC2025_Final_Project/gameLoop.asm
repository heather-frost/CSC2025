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
prompt              byte  "Opening gameLoop prompt here: OLD PROMPT: Enter a number between 1 and 45: ", 0
; beginning with 10 sends a line feed character before the text
gameLoopDialog     byte  10,"Starting with 1 and 2, the terms produced are: ",0
invalidInputDialog    byte  "Please enter a valid input.",10,10,0
gameOverDialog      byte    "You blew up!",10,10,0
finalTerm           byte  10,10,"The value of term ",0
finalDialog         byte  "is "

.code

;; Call gameLoop() - No Parameters, no return value
gameLoop PROC near
_gameLoop:

Setup:
;GAME SETUP GOES HERE

gameLoopStart:
    ; DISPLAY GAME STATE
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

    ; ACCEPT USER INPUT
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
    jg invalidInputError
    cmp ebx,1
    jl invalidInputError

random:
   MOV AH, 00h  ; get system time

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; dx now contains [0-9] remainder of division

   mov ax, dx
   xor dx, dx
   mov cx, 2
   div cx       ; ax now contains [0-4]

   cmp ax, 4
   je random    ; don't want 4s

   mov dx, ax
   mov eax, 0
   add ax, dx  ;random [0-3] is in eax

    

;VICTORY
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

playAgain:
    
exit:
    ret     ; Return to the main program.

gameOver:
    ; Print gameOverDialog
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset gameOverDialog
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset gameOverDialog
    call  writeline
    jmp playAgain
; End gameOver

invalidInputError:
    ; Print invalidInputDialog
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset invalidInputDialog
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset invalidInputDialog
    call  writeline
    jmp _gameLoop
; End invalidInputError
    
gameLoop ENDP
END