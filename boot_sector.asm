
;
; A simple boot sector that prints a message to the screen using a BIOS routine
;

mov ah, 0x0E      ; BIOS teletype function
                  ; int 10/ah = 0eh -> scrolling teletype BIOS routine

mov al, 'H'       ; Load character 'H' into AL
int 0x10          ; Call BIOS interrupt to print character

mov al, 'e'       ; Load character 'e' into AL
int 0x10          ; Call BIOS interrupt to print character
mov al, 'l'       ; Load character 'l' into AL
int 0x10          ; Call BIOS interrupt to print character
mov al, 'l'       ; Load character 'l' into AL
int 0x10          ; Call BIOS interrupt to print character
mov al, 'o'       ; Load character 'o' into AL
int 0x10          ; Call BIOS interrupt to print character

jmp $             ; Jump to the current address(i.e. forever)

;
; Padding and magic BIOS number
;

times 510-($-$$) db 0 ; Pad the boot sector out with zeros to 510 bytes
dw 0xAA55             ; Last two bytes form the magic number,
                      ; so BIOS knows we are a boot sector
