# Bootdev

This is a tiny project for learning simple OS development.

I am learning simple OS dev by exploring how a computer boots, how the BIOS loads a boot sector, and how 16-bit assembly can print text to the screen.

## What I am learning

- BIOS boot process
- Real mode and memory layout
- Boot sector structure
- NASM assembly basics
- Running a custom bootloader in QEMU

## Project files

- `boot_sect.asm` - the boot sector source code
- `boot_sect.bin` - compiled binary output
- `qemu_commands` - example QEMU command to run the project

## Run it

```bash
nasm -f bin boot_sect.asm -o boot_sect.bin
qemu-system-i386 -drive file=boot_sect.bin,format=raw,if=floppy -boot order=a
```

This is a very small step, but it is a good start for understanding how operating systems begin.
