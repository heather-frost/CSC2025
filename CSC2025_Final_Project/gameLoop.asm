; Main Console program
; Spencer Medberry
; 1 November 2024
; gameLoop adapted from fibonacci counter

; Register usage:
;     EAX - external routine communication, card value
;     EBX - card index
;     ECX - counter, row index, column index
;     EDX - storing return address, remainder

.model flat

extern readline: near
extern writeNumber: near
extern clearConsole@0: near
extern printString: near
extern random: near
extern getFirstChar: near

.data

welcomeDialog       byte  "WELCOME TO THE BOMB CARD-FLIP GAME!",10,"Would you like to read how to play? [y/n] ",0
howToDialog1        byte  10,"This is a card flip game. You are presented with 25 cards arranged in 5 rows of 5, all face down. Each card can be ",10,0
howToDialog2        byte  "either 1, 2, 3, or a bomb! Your goal is to flip all the 2s and 3s. If you flip a bomb, you lose. At the end of every ",10,0
howToDialog3        byte  "row and the bottom of every column, the total sum of the non-bomb cards in that row or column is displayed, as well as ",10,0
howToDialog4        byte  "a count of the number of bombs in that row or column. ",10,10,0
howToDialog5        byte  "Are you ready to play? [y/y] ",0
rowPrompt           byte  "Which row would you like to flip a card in? [1-5]: ", 0
columnPrompt        byte  "Which column would you like to flip a card in? [1-5]: ", 0
invalidInputDialog  byte  "Please enter a valid [1-5] input.",10,10,0
gameOverDialog      byte    10,"You blew up!",0
playAgainDialog     byte    10,10,"Would you like to play again? [y/n] ",0
gameTop             byte  " _______________________________________", 10,0
gameRowTop          byte  "|       |       |       |       |       |TOTAL: ",0
gameRowTotalAppend  byte 10, "|",0
gameFrontSpacer     byte  "   ",0
gameBackSpacer      byte  "  |",0
gameRowBombs        byte   "BOMBS: 0",0
gameRowBottom       byte  10,"|_______|_______|_______|_______|_______|", 10,0
gameColumnTotals    byte    "TOT: ",0
gameColumnBombs     byte    "BMB: 0",0
lineEnd             byte    10,0
leadingZero         byte    "0",0
leadingSpace        byte    " ",0
faceDown    byte "? ",0
victorySpeech              byte 10,10,"VICTORY!!!",10,10,0

cardArray db 25 dup(?)
facingArray db 25 dup(?)
rowTotals    db  5 dup(?)
rowBombs    db  5 dup(?)
columnTotals    db  5 dup(?)
columnBombs    db  5 dup(?)

returnAddress dd ?

.code

;; Call gameLoop() - No Parameters, no return value
gameLoop PROC near
_gameLoop:
pop edx
mov [returnAddress], edx
push edx

Welcome:
    push offset welcomeDialog
    call printString
    call readline
    call  getFirstChar
    cmp eax, 110
    je Setup
    cmp eax, 121
    je howTo
    cmp eax, 78
    je Setup
    cmp eax, 89
    je howTo
    jmp Welcome

howTo:
    push offset howToDialog1
    call printString
    push offset howToDialog2
    call printString
    push offset howToDialog3
    call printString
    push offset howToDialog4
    call printString
    push offset howToDialog5
    call printString
    call readline

Setup:

    mov ecx, 0
CardPopulationLoop: ; populates cards w/ [0-3] and sets all face down
    call random
    mov  [cardArray+ecx], al
    mov  [facingArray+ecx], 0
    add  ecx, 1
    cmp  ecx, 25
    jl   CardPopulationLoop
;end card population loop

    mov  ebx, 0
    mov  ecx, 0
rowInfoLoop:
    mov  [rowBombs+ecx], 0
    mov  [rowTotals+ecx], 0
    mov  [columnBombs+ecx], 0
    mov  [columnTotals+ecx], 0
    mov  eax, 0
    rowInfoInnerLoop:
        push eax
        movzx eax, [cardArray+ebx]
        cmp eax, 0
        jg rowTotalAdd
            add [rowBombs+ecx], 1
            jmp rowIncrement
        rowTotalAdd:
            add [rowTotals+ecx], al
        rowIncrement:
        add ebx, 1
        pop eax
        add eax, 1
        cmp eax, 5
        jl  rowInfoInnerLoop
    ;end inner loop
    add ecx, 1
    cmp ecx, 5
    jl  rowInfoLoop
;end rowInfoLoop

    mov ebx, 0
    mov ecx, 0
columnInfoLoop:
    push ecx
    mov  ecx, 0
    columnInfoInnerLoop:
    movzx eax, [cardArray+ebx]
    cmp   eax, 0
    jg columnTotalAdd
        add [columnBombs+ecx], 1
        jmp columnIncrement
    columnTotalAdd:
        add [columnTotals+ecx], al
    columnIncrement:
        add ebx, 1
        add ecx, 1
        cmp ecx, 5
        jl  columnInfoInnerLoop
    pop ecx
    add ecx, 1
    cmp ecx, 5
    jl  columnInfoLoop
;end columnInfoLoop

gameLoopStart:
    ; DISPLAY GAME STATE
    call clearConsole@0 
    push offset gameTop
    call printString

    mov ecx, 0
    printLoop:
        push ecx
        push offset gameRowTop
        call printString
        pop eax
        push eax
        mov edx, 0
        mov ecx, 5
        div ecx
        movzx eax, [rowTotals+eax]
        cmp eax, 10
        jge printRowTot
            push eax
            push offset leadingZero
            call printString
            pop  eax
        cmp eax, 0
        jg  printRowTot
            push eax
            push offset leadingZero
            call printString
            pop  eax
        printRowTot:
        push eax
        call writeNumber
        push offset gameRowTotalAppend
        call printString
        pop ecx
        mov eax, ecx
        add eax, 5
        printSubLoop:
             push eax
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
             pop eax
             cmp ecx, eax
             jge endPrintSubLoop
             jmp printSubLoop
        endPrintSubLoop:
        push ecx
        push offset gameRowBombs
        call printString
        pop eax
        push eax
        mov edx, 0
        mov ecx, 5
        div ecx
        sub eax, 1
        movzx eax, [rowBombs+eax]
        push eax
        cmp eax, 0
        jg printRowBmb
            push offset leadingZero
            call printString
        printRowBmb:
        call writeNumber
        push offset gameRowBottom
        call printString
        pop ecx
        cmp ecx, 25
        jl printLoop
    ;end printLoop
    
    push offset leadingSpace
    call printString
    mov ebx, 0
    mov ecx, 0
    columnTotalsPrint:
        push ecx
        push offset gameColumnTotals
        call printString
        pop ecx
        push ecx
        movzx eax, [columnTotals+ecx]
        cmp eax, 10
        jge printColTot
            push eax
            push offset leadingZero
            call printString
            pop  eax
            cmp eax, 0
            jg  printColTot
                push eax
                push offset leadingZero
                call printString
                pop  eax
        printColTot:
        push eax
        call writeNumber
        pop ecx
        add ecx, 1
        cmp ecx, 5
        jge columnBombsPrintSetup
        jmp columnTotalsPrint

    columnBombsPrintSetup:
        push offset lineEnd
        call printString
        push offset leadingSpace
        call printString
        mov ebx, 0
        mov ecx, 0
    columnBombsPrint:
        push ecx
        push offset gameColumnBombs
        call printString
        pop ecx
        push ecx
        movzx eax, [columnBombs+ecx]
        push eax
        cmp eax, 0
        jg printColBmb
            push offset leadingZero
            call printString
        printColBmb:
        call writeNumber
        pop ecx
        add ecx, 1
        cmp ecx, 5
        jge gamePrintEnd
        jmp columnBombsPrint

gamePrintEnd:
    push offset lineEnd
    call printString
    
guessInput:
    ;Guess Input:Row
    push  offset rowPrompt
    call  printString
    call  readline
    call  getFirstChar
    sub eax,'0'
    cmp eax,5
    jg invalidInputError
    cmp eax,1
    jl invalidInputError
    mov  ebx,eax
    push ebx

    ;Guess Input: Column
    push  offset columnPrompt
    call  printString
    call  readline
    call  getFirstChar
    sub   eax,'0'
    pop   ebx
    cmp   eax,5
    jg invalidInputError
    cmp eax,1
    jl invalidInputError
    sub  ebx, 1
    imul ebx, 5
    add  ebx,eax
    sub  ebx, 1

;gameover check
    movzx eax, [cardArray+ebx]
    cmp  eax,0
    je    gameOver
    
    mov  [facingArray+ebx], 1 ;flip card face up

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
    push offset victorySpeech
    call printString

playAgain:
    push  offset playAgainDialog
    call  printString

    call  readline
    call  getFirstChar

    cmp eax, 110
    je exit
    cmp eax, 121
    je setup
    cmp eax, 78
    je exit
    cmp eax, 89
    je setup
    jmp playAgain
     
exit:
    mov edx, [returnAddress]
    push edx
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
    jmp guessInput
; End invalidInputError
    
gameLoop ENDP
END