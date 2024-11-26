; Main Console program
; Spencer Medberry
; 15 November 2024
; hosts routines for gameLoop.asm

; Register usage:
;     EAX - 
;     EBX - 
;     ECX - 

.model flat

extern writeline: near
extern readline: near
extern charCount: near
extern writeNumber: near

.data

.code

;; Call random()
;; Parameters: none
;; returns random value [0-3]
random PROC near
_random:
    RDRAND EAX

    xor  dx, dx
    mov  cx, 10    
    div  cx        ; dx now contains [0-9] remainder of division

    mov ax, dx
    xor dx, dx
    mov cx, 2
    div cx        ; ax now contains [0-4]

    cmp ax, 4
    je _random    ; don't want 4s
    
    mov dx, ax
    mov eax, 0
    add ax, dx  ;random [0-3] is in eax

    ret
random ENDP
END