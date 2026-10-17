
; ============================================================
; A SIMPLE BIOS BOOT SECTOR
; Purpose: Display "Hello from my boot sector!" on the screen
; Assembler: NASM
; Output: A raw binary file of exactly 512 bytes
; ============================================================

; ------------------------------------------------------------
; 1. TELL NASM THAT WE ARE WRITING 16-BIT CODE
; ------------------------------------------------------------

bits 16
; 'bits 16' tells NASM to generate 16-bit instruction encodings.
; This is appropriate because a traditional BIOS starts the
; boot process in 16-bit real mode.
;
; IMPORTANT: This directive does not switch the CPU into
; 16-bit mode. The BIOS has already started us in real mode.


; ------------------------------------------------------------
; 2. TELL NASM THE EXPECTED MEMORY ADDRESS OF OUR CODE
; ------------------------------------------------------------

org 0x7C00
; 'org' means origin.
; It tells NASM to calculate addresses as if the first byte
; of our program will be loaded at memory address 0x7C00.
;
; 0x7C00 is the conventional physical address where the BIOS
; loads a traditional boot sector.
;
; IMPORTANT: 'org' does not load the program into memory.
; The BIOS performs the actual loading.


; ------------------------------------------------------------
; 3. PROGRAM ENTRY POINT
; ------------------------------------------------------------

start:
    mov si, message
    ; MOV means copy a value from one place to another.
    ;
    ; SI is the Source Index register, a 16-bit CPU register.
    ; We store the address of the first character of 'message'
    ; in SI so the CPU knows where our text begins.
    ;
    ; Because of 'org 0x7C00', NASM calculates this address
    ; as a memory address based on the program's load location.


; ------------------------------------------------------------
; 4. READ AND DISPLAY THE MESSAGE ONE CHARACTER AT A TIME
; ------------------------------------------------------------

print:
    lodsb
    ; LODSB means "Load String Byte".
    ;
    ; It reads one byte from memory at address DS:SI and puts
    ; that byte into the AL register.
    ;
    ; DS is the Data Segment register.
    ; SI holds the offset of the next byte to read.
    ; AL is the low 8-bit part of the AX register.
    ;
    ; After reading, SI normally increases by 1 because the
    ; Direction Flag is clear in the usual BIOS startup state.
    ; For robust code, we could explicitly execute CLD first.


    cmp al, 0
    ; CMP means compare.
    ; It compares AL with zero by setting CPU status flags.
    ; It does not change the value stored in AL.
    ;
    ; Our message ends with a zero byte.
    ; Therefore, AL = 0 means we have reached the end.


    je halt
    ; JE means "Jump if Equal".
    ; If the previous comparison found AL = 0, jump to 'halt'.
    ; Otherwise, continue to the next instruction.


    mov ah, 0x0E
    ; AH is the upper 8-bit part of AX.
    ;
    ; BIOS video interrupt 0x10 provides several video services.
    ; Function 0x0E means teletype output.
    ;
    ; Setting AH to 0x0E tells the BIOS what video service
    ; we want to use.
    ;
    ; AL still contains the character we want to display.


    int 0x10
    ; INT means interrupt.
    ; INT 0x10 invokes the BIOS video service.
    ;
    ; With AH = 0x0E, the BIOS displays the character in AL
    ; at the current cursor position and advances the cursor.


    jmp print
    ; JMP means unconditional jump.
    ; Return to the 'print' label to process the next character.
    ;
    ; The loop continues until the zero terminator is reached.


; ------------------------------------------------------------
; 5. STOP THE PROGRAM FROM CONTINUING INTO OTHER DATA
; ------------------------------------------------------------

halt:
    jmp halt
    ; Jump to the same instruction forever.
    ;
    ; This creates an infinite loop, keeping the CPU here.
    ; Otherwise, execution could continue into the message,
    ; padding bytes, or boot signature.
    ;
    ; A more power-conscious loop could use HLT, but this
    ; simple jump is easy to understand.


; ------------------------------------------------------------
; 6. THE MESSAGE TO DISPLAY
; ------------------------------------------------------------

message:
    db 'Hello from my boot sector!', 0
    ; DB means "Define Byte".
    ;
    ; NASM converts each character into its numeric byte value.
    ; For example:
    ;   'H' = 0x48
    ;   'e' = 0x65
    ;   'l' = 0x6C
    ;
    ; The final 0 is a null terminator.
    ; It tells our program where the message ends.
    ; LODSB reads this zero, and JE halt detects it.


; ------------------------------------------------------------
; 7. PAD THE BINARY TO 510 BYTES
; ------------------------------------------------------------

times 510-($-$$) db 0
    ; $$ represents the beginning of this assembly section.
    ; $ represents the current assembly position.
    ; ($ - $$) is the number of bytes generated so far.
    ;
    ; 510 - ($ - $$) calculates how many zero bytes are needed
    ; to make the binary reach 510 bytes.
    ;
    ; TIMES repeats the following DB instruction that many
    ; times, filling the unused space with zero bytes.
    ;
    ; This leaves the final two bytes for the boot signature.


; ------------------------------------------------------------
; 8. WRITE THE BIOS BOOT SIGNATURE
; ------------------------------------------------------------

dw 0xAA55
    ; DW means "Define Word" (16 bits, or 2 bytes).
    ;
    ; On x86, multi-byte values are stored little-endian.
    ; Therefore, 0xAA55 is written as:
    ;
    ;   First byte: 0x55
    ;   Second byte: 0xAA
    ;
    ; These final bytes form the conventional BIOS boot
    ; signature. The BIOS uses this signature when validating
    ; a traditional boot sector.
