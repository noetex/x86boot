ENTRY(main)
ENTRY(MultibootEntry)

OUTPUT_FORMAT("binary")
OUTPUT_FORMAT("pe-i386")
OUTPUT_FORMAT("elf32-i386")
OUTPUT_FORMAT("elf64-x86-64")

STARTUP(Boot.o)  // It is which file you want to be linked to the very beginning of the executable
STARTUP(crt0.o)

SEARCH_DIR(Directory)


INPUT(File1.o File2.o File3.o ...)
INPUT
(
	File1.o
	File2.o
	File3.o
	...
)

OUTPUT(Kernel.bin)


MEMORY
{
    ROM (rx) : ORIGIN = 0, LENGTH = 256k
    RAM (wx) : org = 0x00100000, len = 1M
}

SECTIONS
{
  .text.start (_KERNEL_BASE_) : {
    startup.o( .text )
  }

  .text : ALIGN(CONSTANT(MAXPAGESIZE)) {
_TEXT_START_ = .;
    *(.text)
_TEXT_END_ = .;
  }

  .data : ALIGN(CONSTANT(MAXPAGESIZE)) {
_DATA_START_ = .;
    *(.data)
_DATA_END_ = .;
  }

  .bss : ALIGN(CONSTANT(MAXPAGESIZE)) {
_BSS_START_ = .;
    *(.bss)
_BSS_END_ = .;
  }
}

SECTIONS
{
	.text :
	{
		KEEP(*(.text.ivt))
		*(.text.boot)
		*(.text*)
	} > ROM

	/** ... **/
}

floating_point = 0;
SECTIONS
{
  .text :
    {
      *(.text)
      _etext = .;
    }
  _bdata = (. + 3) & ~ 3;
  .data : { *(.data) }
}

/** Externally linked symbol */
extern uintptr_t _etext;
// ...
/** Pointer to the binary data at the address stored in the symbol expression. */
uint32_t* item = &_etext;
