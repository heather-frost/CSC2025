; MASM Template
; Spencer Medberry
; 09/18/2024
; Create a template for assembler files.

.386P
.model flat

extern   _ExitProcess@4: near

.data

.code
main PROC near
_main:

	push	0
	call	_ExitProcess@4

main ENDP
END 