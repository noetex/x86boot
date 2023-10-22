@echo off

if not exist "build" mkdir "build"
set img_filename="build\system.img"
set bin_filename="build\kernel.bin"
set obj_filename="build\kernel.obj"
set obj_filename2="build\routines.o"

call nasm bootstrap.asm -f bin -o %img_filename%

rem set base_flags=-c -m32 --target=x86_64-pc-none-elf -flto
set base_flags=-c -m32 --target=x86_64-pc-none-elf

call clang main.c %base_flags% -o %obj_filename% -ffreestanding
call clang routines.asm %base_flags% -o %obj_filename2%
call ld.lld %obj_filename% %obj_filename2% --oformat=binary --section-start=.text=0x7e00 -o %bin_filename%

type %bin_filename% >> %img_filename%

if "%1" equ "run" (
	rem copy /v /b %img_filename% d:\system.img
	rem call qemu-system-x86_64 -hda /dev/sdx
	call qemu-system-x86_64w %img_filename%
)
