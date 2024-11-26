; Main Console program
; Spencer Medberry
; 15 November 2024
; hosts routines for gameLoop.asm

; Register usage:
;     EAX - routine communication
;     EBX - holds parameter
;     EDX - return address juggling

.model flat

extern writeline: near
extern readline: near
extern charCount: near
extern writeNumber: near

.data

.code

;; Call printString(string)
;; Parameters: address of string to be printed
printString PROC near
_printString:
    pop  edx
    pop  ebx
    push edx
        ;; Call charCount(addr)
        ;; Parameters: addr is address of buffer = &addr[0]
        ;; Returns character count in eax
    push  ebx
    push  ebx
    call  charCount
        ;; Call writeline(addr, chars) - push parameter in reverse order
        ;; Parameters: addr is address of buffer = &addr[0]
        ;;             chars is the character count in the buffer
        ;; Returns nothing
    pop   ebx
    push  eax
    push  ebx
    call  writeline
    ret
printString ENDP
END