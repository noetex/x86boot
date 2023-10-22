typedef struct
{
	uint16_t OffsetLo;
	uint16_t Selector;
	uint8_t Zero;
	uint8_t Attribute;
	uint16_t OffsetHi;
} __attribute__((packed)) idt_entry;

typedef struct
{
	uint16_t Size;
	uint32_t Address;
} __attribute__((packed)) idt_desc;

extern void load_the_idt(idt_desc*);

static void
init_idt(void* Address, size_t Size)
{

}
