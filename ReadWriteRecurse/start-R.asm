; Factorial asm file
; Spencer Medberry
; 12 October 2024

; Register usage:
;     EAX - readWrite procedure communication, factorial routine result
;     EBX - integer user input result for passing to factorial routine
;     ECX - char storage during ASCII conversion

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

;; Call start() - no parameters, no return value
start PROC near
_start:
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

    ; print input number for factorialDialog to reference
    push  offset numberBuffer        ; Supplied buffer where number is written.call  writeline
    push  ebx
        ;; Call genNumber(numberBuffer, value)
        ;; Parameters: numberBuffer
        ;;             value
        ;; Return ASCII number
    call  genNumber
    pop   eax                        ; PARAMETER MUST BE REMOVED HERE TO EXIT PROPERLY.
    pop   eax                        ; Remove second parameter.
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset numberBuffer        ; Supplied buffer where number is written.
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset numberBuffer
    call  writeline                 ; And it is time to exit.

    ; print factorialDialog
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset factorialDialog
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset factorialDialog
    call  writeline

    ;prep registers for factorial loop
    pop ebx
    mov eax, 1

        ;; Call factorial() - No Parameters, no return value
    call factorial

    ;print result
        ;; Call genNumber(numberBuffer, value)
        ;; Parameters: numberBuffer
        ;;             value
        ;; Return ASCII number
    push  offset numberBuffer        ; Supplied buffer where number is written.call  writeline
    push  eax
    call  genNumber
    pop   eax                        ; PARAMETER MUST BE REMOVED HERE TO EXIT PROPERLY.
    pop   eax                        ; Remove second parameter.

        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  offset numberBuffer        ; Supplied buffer where number is written.
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    push  eax
    push  offset numberBuffer
    call  writeline

exit:
    ret   ; Return to the main program.
start ENDP

;; Call factorial() - No Parameters, no return value
factorial PROC near
_factorial:
    cmp ebx, 1
    jle factorialExit
    imul eax, ebx
    dec ebx
        ;; Call factorial() - No Parameters, no return value
    call factorial
factorialExit:
    ret
factorial ENDP

END