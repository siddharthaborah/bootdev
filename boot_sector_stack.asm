;
; Simple boot sector program that demonstrates stack usage.
;

mov ah, 0x0E            ; BIOS teletype function
                        ; int 10/ah = 0eh -> scrolling teletype BIOS routine

mov bp, 0x8000          ; Set up the stack pointer to 0x8000
                        ; This is a safe area in memory for our stack
mov sp, bp              ; Initialize the stack pointer (SP) to the value in BP

push 'A'                ; Push character 'A' onto the stack
push 'B'                ; Push character 'B' onto the stack
push 'C'                ; Push character 'C' onto the stack

pop bx                  ; Note , we can only pop 16 bits, so pop to bx
mov al, bl              ; then copy bl (i.e. 8 bit char) to al
int 0x10                ; Call BIOS interrupt to print character

pop bx                 ; Pop the next character into bx
mov al, bl              ; Copy bl to al
int 0x10                ; Call BIOS interrupt to print character

mov al, [0x7ffe]        ; To prove our stack grows downwars from bp,
                        ; fetch the char at 0x800 - 0x2(i.e. 16 bits)
int 0x10                ; Call BIOS interrupt to print character

jmp $                   ; Jump to the current address(i.e. forever)

; padding and magic BIOS number

times 510 - ($ - $$) db 0
dw 0xaa55               ; Last two bytes form the magic number,
                        ; so BIOS knows we are a boot sector



