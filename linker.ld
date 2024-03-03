ENTRY(_start)

SECTIONS
{
    . = 0x10000; /* Example load address, adjust as needed */

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
        *(.rodata)
    }

    .bss : {
        *(.bss)
    }
}
