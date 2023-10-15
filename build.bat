@echo off

if not exist "build" mkdir "build"
set img_filename="build\the_image.img"
set bin_filename="build\kernel.bin"
set obj_filename="build\kernel.obj"

call nasm bootstrap.asm -f bin -o %img_filename%
call clang main.c -c -target x86_64-pc-none-elf -ffreestanding -o %obj_filename%
call ld.lld %obj_filename% --oformat=binary --section-start=.text=0 -o %bin_filename%

type %bin_filename% >> %img_filename%
