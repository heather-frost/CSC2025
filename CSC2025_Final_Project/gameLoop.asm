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
prompt              byte  "Opening gameLoop prompt here: OLD PROMPT: Enter a number between 1 and 5: ", 0
; beginning with 10 sends a line feed character before the text
gameLoopDialog     byte  10,"Starting with 1 and 2, the terms produced are: ",0
invalidInputDialog    byte  "Please enter a valid [1-5] input.",10,10,0
gameOverDialog      byte    "You blew up!",10,10,0
playAgainDialog     byte    10,10,"Would you like to play again? [y/n] ",0
finalTerm           byte  10,10,"The value of term ",0
finalDialog         byte  "is ",0

cardArray db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
;cardArray db '1','2','3','4','5','6','7','8','9','0','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25'
;cardArray db 25 dup(0)

.code

;; Call gameLoop() - No Parameters, no return value
gameLoop PROC near
_gameLoop:

Setup:
;GAME SETUP GOES HERE

gameLoopStart:
    ; DISPLAY GAME STATE

    ; DISPLAY GAME STATE [PLACEHOLDER FOR ROW DIALOG]
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

    mov  cl,[eax]                   ; Look at the character in the string
    sub  cl,'0'
    add  ebx,ecx

    cmp ebx,5
    jg invalidInputError
    cmp ebx,1
    jl invalidInputError
    push ebx

    
    ; DISPLAY GAME STATE [PLACEHOLDER FOR COLUMN DIALOG]
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
    pop   ebx
    sub  ebx, 1
    imul ebx, 5

    mov  cl,[eax]                   ; Look at the character in the string
    sub  cl,'0'

    cmp ecx,5
    jg invalidInputError
    cmp ecx,1
    jl invalidInputError
    add  ebx,ecx

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
    mov  ebx, 0
    mov  bl, [cardArray+8]
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
    ; PLAY AGAIN?
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset playAgainDialog
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset playAgainDialog
    call  writeline

    ; ACCEPT USER INPUT
        ;; Call readline() - No Parameters, Returns ptr to buffer in eax
    call  readline
    ; user input stored in eax
    
    ; Look at the character in the string
    mov   ecx,0
    mov  cl,[eax]

    cmp ecx, 110
    je exit
    cmp ecx, 78
    je exit
    cmp ecx, 121
    je gameLoopStart
    cmp ecx, 89
    je gameLoopStart
    jmp playAgain
     
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