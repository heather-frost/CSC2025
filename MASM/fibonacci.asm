; Main Console program
; Spencer Medberry
; 27 September 2024
; fibonacci counter built from start.asm
; SAM updated based on feedback 10/12/2024

; Register usage:
;     EAX - readWrite procedure communication, fibonacci sum
;     EBX - integer user input result for term counting
;     ECX - helper register: char storage during ASCII conversion, lesser fibonacci addend

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

;; Call fibonacci() - No Parameters, no return value
fibonacci PROC near
_fibonacci:
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
    push ebx
    

    ; Print numberPrint dialog
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset numberPrint
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset numberPrint
    call  writeline

    ;prep registers for addloop
    pop ebx
    mov   eax, 2
    mov   ecx, 1

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

exit:
    ret                                     ; Return to the main program.
fibonacci ENDP
END