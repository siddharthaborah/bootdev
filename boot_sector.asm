;
; A simple boot sector program that demonstrates addressing.
;
         ; Origin, where the BIOS loads the boot sector
mov ah, 0x0E            ; BIOS teletype function
                        ; int 10/ah = 0eh -> scrolling teletype BIOS routine

; first attempt
mov al, the_secret      ; In this only the offset of the_secret is loaded into AL, not the value at that address
int 0x10                ; Does this print an X ?

; second attempt
mov al, [the_secret]    ; here the value at the address of the_secret is loaded into AL but this is not the correct address since the_secret is at 0x7C1D and not 0x001D
int 0x10                ; Does this print an X ?

; Third attempt
mov bx , the_secret     ; Store the offset or address of the_secret in BX
add bx, 0x7c00          ; Add the origin of the boot sector to get the absolute address
mov al, [bx]            ; Load the byte at the absolute address into AL
int 0x10                ; Does this print an X ?

; Fourth attempt
mov al, [0x7C1D]        ; Here we are using the absolute address of the_secret to load the value into AL
int 0x10                ; Does this print an X ?

jmp $                   ; Jump to the current address(i.e. forever)


the_secret:
    db 'X'

; Padding and magic BIOS number

times 510 - ($ - $$) db 0
dw 0xaa55               ; Last two bytes form the magic number,
                        ; so BIOS knows we are a boot sector
