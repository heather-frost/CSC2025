; Show how to print Hello
; Spencer Medberry
; 09/23/2024
; Print "Hello World!" and "Hello Now"
.386P

.model flat

extern _GetStdHandle@4:near
extern _ExitProcess@4: near
extern _WriteConsoleA@20:near
extern _ReadConsoleA@20:near

.data

msg byte 'Hello World!', 10,0
msg1 byte 'Hello Now', 10,0
handle dword  ?
written dword  ?


.code

main PROC near
_main:

   ; handle = GetStdHandle(-11)
   push -11
   call _GetStdHandle@4
   mov    handle, eax
   ; WriteConsole(handle, msg[0], 14, written, 0)
   push 0
   push offset written
   push 13
   push offset msg
   mov eax, offset msg
   push handle
   call _WriteConsoleA@20

   ; WriteConsole(handle, msg1[0], 12, written, 0)
   push 0
   push offset written
   push 11
   push offset msg1
   push handle
   call _WriteConsoleA@20

   push 0
   call _ExitProcess@4

main ENDP
END