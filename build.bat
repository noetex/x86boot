@echo off

if not exist "build" (
	mkdir "build"
)
pushd %build_dir%
set nasm_flags=-f bin -o build/bootloader.bin
call nasm %nasm_flags% main.asm
popd
