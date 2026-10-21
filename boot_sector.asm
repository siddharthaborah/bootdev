;
; A simple boot sector program that demonstrates addressing.
;
         ; Origin, where the BIOS loads the boot sector
mov ah, 0x0E      ; BIOS teletype function
                  ; int 10/ah = 0eh -> scrolling teletype BIOS routine

; first attempt
mov al, the_secret
int 0x10          ; Does this print an X ?

; second attempt
mov al, [the_secret]
int 0x10          ; Does this print an X ?

; Third attempt
mov bx , the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10          ; Does this print an X ?

; Fourth attempt
mov al, [0x7C1D]
int 0x10          ; Does this print an X ?

jmp $             ; Jump to the current address(i.e. forever)


the_secret:
    db 'X'

; Padding and magic BIOS number

times 510 - ($ - $$) db 0
dw 0xaa55             ; Last two bytes form the magic number,
                      ; so BIOS knows we are a boot sector
