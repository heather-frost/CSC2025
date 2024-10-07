; Main Console program
; Spencer Medberry
; 27 September 2024
; fibonacci counter built from start.asm

; Register names:
;     EAX - Caller saved register - used for addend
;     EBX - Caller saved register - used for sum
;     ECX - Caller saved register - Counter register 
;     EDX - Caller saved register - data
;     ESI - Callee Saved register - Source Index
;     EDI - Callee Saved register - Destination Index
;     ESP - Callee Saved register - stack pointer
;     EBP - Callee Saved register - base pointer.386P

.model flat

extern writeline: near
extern readline: near
extern charCount: near
extern writeNumber: near

.data

prompt          byte  "How many fibonacci terms would you like? Enter a number between 1 and 45: ", 0 ; ends with string terminator (NULL or 0)
numberPrint     byte  10,"Starting with 1 and 2, the terms produced are: ",0
results         byte  10,"The number of terms that will be displayed is: ", 0
numCharsToRead  dword 1024
bufferAddr      dword ?

.code

; Library calls used for input from and output to the console; This is the entry procedure that does all of the testing.
fibonacci PROC near
_fibonacci:
    ; Type a prompt for the user
    ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
    push  offset prompt
    call  charCount
    push  eax
    push  offset prompt
    call  writeline

    ; Read what the user entered.
    call  readline
    
    ;convert user entry to number
    mov   bufferAddr, eax
    mov   ebx, bufferAddr
    mov   ecx,0
    mov   eax,0
ASCIIloop:
    mov  cl,[ebx]                   ; Look at the character in the string
    cmp  ecx,13                     ; check for carriage return.
    je numberGet
    cmp  ecx,10                     ; check for line feed.
    je numberGet
    cmp  ecx,0                      ; check for end of string.
    je numberGet
    sub  cl,'0'
    imul eax,10
    add  eax,ecx
    inc  ebx                        ; go to next letter
    jmp  ASCIIloop
numberGet:
    push eax

    ; Print numberPrint dialog
    push  offset numberPrint
    call  charCount
    push  eax
    push  offset numberPrint
    call  writeline

    ;prep registers for addloop
    pop ecx
    mov   eax, 2
    mov   ebx, 1
;    mov   ecx, 10

addloop:
    ;add function
    push  eax
    add   eax, ebx
    pop   ebx

    ;store registers
    push  eax
    push  ebx
    push  ecx

    ;writeNumber
    push  eax
    call  writeNumber

    ;retrieve registers
    pop   ecx
    pop   ebx
    pop   eax

    ;loopy bit
    dec ecx
    cmp ecx,0
    jg  addloop

exit:
    ret                                     ; Return to the main program.
fibonacci ENDP
END