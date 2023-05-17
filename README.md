# x86boot
A first stage MBR bootloader for x86-based processors.

## How to build:
(note: the instruction below assume a Windows build environment for now)
### Prerequisites:
* NASM
* QEMU
```.bat
git clone https://github.com/ziloet/x86boot
cd x86boot
build.bat
cd build
call qemu-system-x86_64.exe -drive format=raw,file=build/bootloader.bin
```

## About Running
Although QEMU is used here, but this can be any x86 emulator as well.\
Or better than an emulator: try it on actual hardware!
