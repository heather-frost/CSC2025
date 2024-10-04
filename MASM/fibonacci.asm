; Main Console program
; Spencer Medberry
; 27 September 2024
; fibonacci counter built from start.asm

; Register names:
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

prompt          byte  "How many fibonacci terms would you like? Enter a number between 1 and 45: ", 0 ; ends with string terminator (NULL or 0)
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
    
    push  offset numberPrint
    call  charCount
    push  eax
    push  offset numberPrint
    call  writeline
    mov   eax, addend2
    mov   ebx, addend1
    mov   ecx, 0

progressloop:
    call fprogress
    call fprogress
    call fprogress
    call fprogress
    call fprogress

exit:
    ret                                     ; Return to the main program.

fibonacci ENDP

fprogress PROC near
_fprogress:
    push  eax
    add   eax, ebx
    pop   ebx
    push  eax
    push  ebx
    push  eax
    call  writeNumber
    pop   ebx
    pop   eax
    ret
fprogress ENDP

END