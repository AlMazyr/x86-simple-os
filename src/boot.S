/* Mutiboot header */

.set MULTIBOOT2_MAGIC,		0xE85250D6
.set MULTIBOOT2_ARCH,		0
.set MULTIBOOT2_SIZE,		multiboot_header_end - multiboot_header
.set MULTIBOOT2_CHECKSUM,	-(MULTIBOOT2_MAGIC + MULTIBOOT2_ARCH + MULTIBOOT2_SIZE)

.section .multiboot
.align 8
multiboot_header:
.long MULTIBOOT2_MAGIC
.long MULTIBOOT2_ARCH
.long MULTIBOOT2_SIZE
.long MULTIBOOT2_CHECKSUM
// end tag
.short 0
.short 0
.long 8
multiboot_header_end:

.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:


.section .text
.code32
.global _start
.type _start, @function
_start:
	mov $stack_top, %esp	//setup stack

//TODO: init IRQS
//TODO: init paging

	call kernel_main
	cli
1:
	hlt
	jmp 1b

.size _start, . - _start
