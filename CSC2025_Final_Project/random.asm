; Main Console program
; Spencer Medberry
; 26 November 2024
; generates random value [0-3]

; Register usage:
;     EAX - random dividend, result
;     ECX - divisor
;     EDX - remainder

.model flat

.data

.code

;; Call random()
;; Parameters: none
;; returns random value [0-3]
random PROC near
_random:
    push ecx
    rdrand eax      ; put random value in eax
    mov dx, 0     ; clear dx to hold remainder
    mov cx, 4       ; set divisor to 4
    div cx          ; dx now contains [0-4]
    movzx eax, dx   ; random [0-3] is in eax
    pop ecx
    ret
random ENDP
END