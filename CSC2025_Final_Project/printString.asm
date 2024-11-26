; Main Console program
; Spencer Medberry
; 15 November 2024

; Register usage:
;     EAX - external routine communication
;     EBX - parameter

.model flat

extern writeline: near
extern charCount: near

.data

.code

;; Call printString(string)
;; Parameters: address of string to be printed
printString PROC near
_printString:
    pop  eax
    pop  ebx
    push eax
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