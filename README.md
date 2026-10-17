# Bootdev

This is a tiny project for learning simple OS development.

## What I am learning

- BIOS boot process
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

In this repo I am following Writing a Simple Operating System -- from Scratch by by Nick Blundell
