; Main Console program
; Spencer Medberry
; 1 November 2024
; gameLoop adapted from fibonacci counter

; Register usage:
;     EAX - external routine communication
;     EBX - 
;     ECX - 

.model flat

extern writeline: near
extern readline: near
extern charCount: near
extern writeNumber: near
extern printString: near

.data

rowPrompt               byte  "Which row would you like to flip a card in? [1-5]: ", 0
columnPrompt               byte  "Which column would you like to flip a card in? [1-5]: ", 0
gameLoopDialog     byte  10,"Starting with 1 and 2, the terms produced are: ",0

invalidInputDialog    byte  "Please enter a valid [1-5] input.",10,10,0

gameOverDialog       byte    10,"You blew up!",0
playAgainDialog     byte    10,10,"Would you like to play again? [y/n] ",0
finalTerm            byte  10,10,"The value of term ",0
finalDialog          byte  "is ",0

gameTop              byte  " _______________________________________", 10,0
gameRowTop           byte  "|       |       |       |       |       |TOTAL: ",0
gameRowTotalAppend   byte 10, "|",0
gameFrontSpacer        byte  "   ",0
gameBackSpacer        byte  "  |",0
gameRowBombs         byte   "BOMBS: ",0
gameRowBottom        byte  10,"|_______|_______|_______|_______|_______|", 10,0

victorySpeech              byte 10,10,"VICTORY!!!",10,10,0

cardArray db 25 dup(?)
facingArray db 25 dup(0)
rowTotals    db  5 dup(0)
rowBombs    db  5 dup(0)
columnTotals    db  5 dup(0)
columnBombs    db  5 dup(0)

faceDown    byte "? ",0


.code

;; Call gameLoop() - No Parameters, no return value
gameLoop PROC near
_gameLoop:

Setup:
; populates cardArray w/ [0-3]
    mov ebx, 0
StaticPopulationLoop:
    RDRAND EAX

    xor  dx, dx
    mov  cx, 10    
    div  cx        ; dx now contains [0-9] remainder of division

    mov ax, dx
    xor dx, dx
    mov cx, 2
    div cx        ; ax now contains [0-4]

    cmp ax, 4
    je StaticPopulationLoop    ; don't want 4s
    
    mov dx, ax
    mov eax, 0
    add ax, dx  ;random [0-3] is in eax

    mov [cardArray+ebx], al
    add ebx, 1
    cmp ebx, 26
    jl StaticPopulationLoop
    mov [facingArray], 0

    mov ebx, 0
rowInfoLoop:
    movzx eax, [cardArray+ebx]
    cmp eax, 0
    jg rowTotalAdd
    add [rowBombs], 1
    jmp rowIncrement
    rowTotalAdd:
    add [rowTotals], al
    rowIncrement:
    add ebx, 1
    cmp ebx, 5
    jl rowInfoLoop
;end rowInfoLoop


gameLoopStart:
    ; DISPLAY GAME STATE
    push offset gameTop
    call printString
    mov ecx, 0
    printLoop:
        push ecx
        push offset gameRowTop
        call printString
        push eax
        movzx eax, [rowTotals]
        push eax
        call writeNumber
        pop eax
        push offset gameRowTotalAppend
        call printString
        pop ecx
        mov edx, ecx
        add edx, 5
        push edx
        printSubLoop:
             push edx
             push ecx
             push offset gameFrontSpacer
             call printString
             pop ecx
             push ecx
             mov ebx, 0
             mov bl, [facingArray+ecx]
             cmp ebx, 0
             jg faceup

             push offset faceDown
             call printString
             jmp facingDone

             faceup:
             mov bl, [cardArray+ecx]
             push ebx
             call writeNumber

             facingDone:
             push offset gameBackSpacer
             call printString
             pop ecx
             add ecx, 1
             pop edx
             cmp ecx, edx
             jge endPrintSubLoop
             jmp printSubLoop
        endPrintSubLoop:
        pop edx
        push ecx
        push offset gameRowBombs
        call printString
        push eax
        movzx eax, [rowBombs]
        push eax
        call writeNumber
        pop eax
        push offset gameRowBottom
        call printString
        pop ecx
        cmp ecx, 25
        jl printLoop
    ;end printLoop

    ;Guess Input:Row
    push  offset rowPrompt
    call  printString
    call  readline
    
    ;convert user input from ASCII to integer
    mov    ecx,0
    mov    ebx,0

    mov  cl,[eax]                    ; Look at the character in the string
    sub  cl,'0'
    add  ebx,ecx

    cmp ebx,5
    jg invalidInputError
    cmp ebx,1
    jl invalidInputError
    push ebx

    ;Guess Input: Column
    push  offset columnPrompt
    call  printString
    call  readline
    
    ;convert user input from ASCII to integer
    mov    ecx,0
    pop    ebx
    sub  ebx, 1
    imul ebx, 5

    mov  cl,[eax]                    ; Look at the character in the string
    sub  cl,'0'

    cmp ecx,5
    jg invalidInputError
    cmp ecx,1
    jl invalidInputError
    add  ebx,ecx

;gameover check
    mov  eax, 0
    sub  ebx, 1
    mov  al, [cardArray+ebx]
    mov  [facingArray+ebx], 1
    cmp  eax,0
    je    gameOver

    mov ecx, 0
victoryCheck:
    movzx eax, byte ptr [facingArray+ecx]
    cmp eax, 1
    je victoryCheckContinue
    movzx eax, byte ptr [cardArray+ecx]
    cmp eax, 2
    jge gameLoopStart
victoryCheckContinue:
    add ecx, 1
    cmp ecx, 25
    jge victory
    jmp victoryCheck

victory:
    push eax    ;2nd writeNumber parameter
    add  ebx, 1
    push ebx    ;1st writeNumber parameter
    push  offset finalTerm
    call  printString

    call  writeNumber

    push  offset finalDialog
    call  printString

    call  writeNumber

    push offset victorySpeech
    call printString


playAgain:
    push  offset playAgainDialog
    call  printString

    call  readline
    
    ; Look at the character in the string
    mov    ecx,0
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
    push  offset gameOverDialog
    call  printString
    jmp playAgain
; End gameOver

invalidInputError:
    ; Print invalidInputDialog
    push  offset invalidInputDialog
    call  printString
    jmp gameLoopStart
; End invalidInputError
    
gameLoop ENDP
END