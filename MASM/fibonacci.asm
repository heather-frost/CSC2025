; Main Console program
; Spencer Medberry
; 27 September 2024
; fibonacci counter built from start.asm

; Register names:
; Register names are NOT case sensitive eax and EAX are the same register
; x86 uses 8 registers. EAX (Extended AX register has 32 bits while AX is
;	the right most 16 bits of EAX). AL is the right-most 8 bits.
; Writing into AX or AL effects the right most bits of EAX.
;     EAX - caller saved register - usually used for communication between
;			caller and callee.
;     EBX - Callee saved register
;     ECX - Caller saved register - Counter register 
;     EDX - Caller Saved register - data, I use it for saving and restoring
;			the return address
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

prompt          byte  "How many fibonacci terms would you like? Enter a number between 0 and 45: ", 0 ; ends with string terminator (NULL or 0)
results         byte  10,"You typed: ", 0
numberPrint     byte  10,"Starting with 1 and 2, the terms produced are: ",0
addend1         dword 1
addend2         dword 2
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

    ; The following embeds the above code in a common routine, so the more complicated call only needs to be written once.
    ; writeline(&results[0], 12)
    mov   bufferAddr, eax
    push  offset results
    call  charCount
    push  eax
    push  offset results
    call  writeline
    push  numCharsToRead
    push  bufferAddr
    call  writeline

    ; Try print a number
    call fprogress

exit:
    ret                                     ; Return to the main program.

fibonacci ENDP

fprogress PROC near
_fprogress:
push  offset numberPrint
    call  charCount
    push  eax
    push  offset numberPrint
    call  writeline
    mov   eax, addend1
    push  eax
    call  writeNumber
    mov   eax, addend2
    push  eax
    call  writeNumber
    mov   eax, addend1
    add   eax, addend2
    mov   addend2, eax
    push  eax
    call  writeNumber
    mov   eax, addend2
    sub   eax, addend1
    mov   addend1, eax
    push  eax
    call  writeNumber
    ret
fprogress ENDP

END