@echo off

if not exist "build" mkdir "build"
set img_filename="build\system.img"
set bin_filename="build\kernel.bin"
set obj_filename="build\kernel.obj"

call nasm bootstrap.asm -f bin -o %img_filename%
call clang main.c -c --target=i386-pc-none-elf -ffreestanding -o %obj_filename%
call ld.lld %obj_filename% --oformat=binary --section-start=.text=0x7e00 -o %bin_filename%

type %bin_filename% >> %img_filename%

if "%1" equ "run" (
	qemu-system-x86_64w %img_filename%
)
