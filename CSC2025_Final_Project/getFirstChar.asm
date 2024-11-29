; Main Console program
; Spencer Medberry
; 26 November 2024

; Register usage:
;     EAX - parameter, result
;     EBX - store first character

.model flat

.data

.code

;; Call getFirstChar()
;; Parameters: string
;;      operates on eax
;;      intended for use with user input
;; returns first character of string
;;      returns in eax
getFirstChar PROC near
_getFirstChar:
    push ebx
    mov    ebx,0
    mov  bl,[eax]
    movzx eax, bl
    pop ebx
    ret
getFirstChar ENDP
END