; Main Console program
; Wayne Cook
; 20 September 2024
; Show how to do input and output
; Revised: WWC 14 March 2024 Added new module
; Revised 15 March 2024 Added this comment ot force a new commit.
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
;     EDI - Callee Saved register - De stination Index
;     ESP - Callee Saved register - stack pointer
;     EBP - Callee Saved register - base pointer.386P

.model flat

; Library calls used for input from and output to the console
extern  _GetStdHandle@4:near
extern  _WriteConsoleA@20:near
extern  _ReadConsoleA@20:near
extern  _ExitProcess@4: near

.data

msg             byte  "Hello, World", 10, 0   ; ends with line feed (10) and NULL
prompt          byte  "Please type your name: ", 0 ; ends with string terminator (NULL or 0)
results         byte  10,"You typed: ", 0
outputHandle    dword ?           ; Input handle reading from console. uninitslized
inputHandle     dword ?           ; Output handle writing to console. uninitslized
written         dword ?
INPUT_FLAG      equ   -10
OUTPUT_FLAG     equ   -11

; Reading and writing requires buffers. I fill them with 00h.
readBuffer      byte  1024        DUP(00h)
writeBuffer     byte  1024        DUP(00h)
numCharsToRead  dword 1024
numCharsRead    dword ?                                   ; Unset or uninitialized


.code

; Initialize Input and Output handles so you only have to do that once.
; This is your first assembly routine
initialize_console PROC near
_initialize_console:

    ; handle = GetStdHandle(-11)
    push    OUTPUT_FLAG
    call    _GetStdHandle@4
    mov     outputHandle, eax
    ; handle = GetStdHandle(-10)
    push  INPUT_FLAG
    call  _GetStdHandle@4
    mov   inputHandle, eax
    ret
initialize_console ENDP

; Now the read/write handles are set, read a line
readline PROC near
_readline: 
      ; ReadConsole(handle, &buffer, numCharToRead, numCharsRead, null)
    push  0
    push  offset numCharsRead
    push  numCharsToRead
    push  offset readBuffer
    push  inputHandle
    call  _ReadConsoleA@20
    ret
readline ENDP

; All strings need to end with a NULL (0). So I do not have to manually count the number of
;   characters in the line, I wrote this routine.
charCount PROC near
_charCount:
    pop  edx                        ; Save return address
    pop  ebx                        ; saqve offset/address of string
    push edx                        ; Put return address back on the stack
    mov  eax,0                      ; load counter to 0
    mov  ecx,0                      ; Clear ECX register
_countLoop:
    mov  cl,[ebx]                   ; Look at the character in the string
    cmp  ecx,0                      ; check for end of string.
    je   _endCount
    inc  eax                        ; Up the count by one
    inc  ebx                        ; go to next letter
    jmp  _countLoop
_endCount:
    ret                             ;Return with EAX containing character count
charCount ENDP

; For all routines, the last item to be pushed on the stack is the return address, save it to a register
; then save any other expected parameters in registers, then restore the return address to the stack.
writeline PROC near
_writeline:
    pop   edx                        ; pop return address from the stack into EDX
    pop   ebx                        ; Pop the buffer location of string to be printed into EBX
    pop   eax                        ; Pop the buffer size string to be printed into EAX.
    push  edx                        ; Restore return address to the stack


    ; WriteConsole(handle, &msg[0], numCharsToWrite, &written, 0)
    push   0
    push   offset written
    push   eax                       ; return size to the stack for the call to _WriteConsoleA@20 (20 is how many bits are in the call stack)
    push   ebx                       ; return the offset of the line to be written
    push   outputHandle
    call   _WriteConsoleA@20
    ret
writeline ENDP

main PROC near
_main:
    call initialize_console                 ; Initialize read and write to console
    ; Type a prompt for the user
    ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
    push  offset prompt
    call  charCount
    push  0
    push  offset written
    push  eax
    push  offset prompt
    mov   eax, offset prompt
    push  outputHandle
    call  _WriteConsoleA@20
    ; Read what the user entered.
    call  readline
    ; The following embeds the above code in a common routine, so the more complicated call only needs to be written once.
    ; writeline(&results[0], 12)
    push  12
    push  offset results
    call  writeline
    push  numCharsToRead
    push  offset readBuffer
    call  writeline
exit:
	push	0
	call	_ExitProcess@4

main ENDP
END