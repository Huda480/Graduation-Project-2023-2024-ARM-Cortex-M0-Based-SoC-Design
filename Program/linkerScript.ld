ENTRY(Reset_Handler)

StackTop = ORIGIN(DRAM) + LENGTH(DRAM);
_Min_Heap_Size = 0x80000 ;    /* required amount of heap  */
_Min_Stack_Size = 0x10000 ;   /* required amount of stack */

MEMORY
{												
	IRAM (rx) : ORIGIN = (0x00000000), LENGTH = 0x100000
	DRAM (rwx)  : ORIGIN = (0x20000000), LENGTH = 0x100000
}

SECTIONS
{

	.text :
	{
		/* interrupt vector table at the start of flash */
		. = ALIGN(4);
		KEEP(*(.vtor));
		. = ALIGN(4);

		/* rest of code & const data */
		*(.text*)
		. = ALIGN(4);
		*(.rodata*)

		. = ALIGN(4);
		_etext = .;
		. = ALIGN(4);
	} >IRAM
	
	
	.data :
	{
		_sdata = .;

		*(.data*)
		
		_edata = .;
	} > DRAM AT > IRAM


	.bss (NOLOAD):
	{
		_sbss = .;

		*(.bss*)
		*(COMMON)

		_ebss = .;
	} > DRAM

	._user_heap_stack :
  	{
		. = ALIGN(4);
		PROVIDE ( end = . );
		PROVIDE ( _end = . );
		. = . + _Min_Heap_Size;
		. = . + _Min_Stack_Size;
		. = ALIGN(4);
	} >DRAM
}
