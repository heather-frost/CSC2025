; Factorial asm file
; Spencer Medberry
; 12 October 2024

; Register usage:
;     EAX - readWrite procedure communication
;     EBX - integer user input result for passing to factorial routine
;     ECX - helper register: char storage during ASCII conversion

;ASSIGNMENT
;   user input: number to perform factorial operation on
;   Convert input from ASCII to integer value
;   Call a routine to calculate factorial result
;   	must be recursive
;   Display result
;three files attached as example
;	genNumber is now recursive
;		works fine, probably could be streamlined


.386P
.model flat

extern writeline: near
extern readline: near
extern charCount: near
extern genNumber: near

.data

prompt          byte  "Please type a number you would like to perform the factorial function on: ", 0 ; ends with string terminator (NULL or 0)
factorialDialog     byte  " factorial is: ",0
numberBuffer    dword 1024

.code

start PROC near
_start:
    ; Display prompt for user input
    push  offset prompt
    call  charCount
    push  eax
    push  offset prompt
    call  writeline

    ; ask console for user input
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
    push ebx

    ; print input number
    push  offset numberBuffer        ; Supplied buffer where number is written.call  writeline
    push  ebx
    call  genNumber
    pop   eax                        ; PARAMETER MUST BE REMOVED HERE TO EXIT PROPERLY.
    pop   eax                        ; Remove second parameter.
    push  offset numberBuffer        ; Supplied buffer where number is written.
    call  charCount
    push  eax
    push  offset numberBuffer
    call  writeline                 ; And it is time to exit.

    ; print factorialDialog
    push  offset factorialDialog
    call  charCount
    push  eax
    push  offset factorialDialog
    call  writeline

    ;prep registers for factorial loop
    pop ebx
    mov eax, 1

    ;FACTORIAL ROUTINE HERE
    call factorial
    mov ebx, eax

    ;print result
    push  offset numberBuffer        ; Supplied buffer where number is written.call  writeline
    push  ebx
    call  genNumber
    pop   eax                        ; PARAMETER MUST BE REMOVED HERE TO EXIT PROPERLY.
    pop   eax                        ; Remove second parameter.

    push  offset numberBuffer        ; Supplied buffer where number is written.
    call  charCount
    push  eax
    push  offset numberBuffer
    call  writeline                 ; And it is time to exit.

exit:
    ret   ; Return to the main program.
start ENDP

factorial PROC near
_factorial:
    cmp ebx, 1
    jle factorialExit
    imul eax, ebx
    dec ebx
    call factorial
factorialExit:
    ret
factorial ENDP

END