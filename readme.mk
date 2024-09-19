I have been tossing around the idea of implementing a MIPS1 chip similar to the R3000 (I have a lot of nostalgia for a certian grey box from the 90s). Additionally, it seems is the right complexity level to challenge me without becoming unmanagable. 

Unfortunately I haven't worked much with the MIPS_1 architecture directly so I wanted to try to create an assembler to familiarize myself with the ISA before diving into a larger project using it.

I will update this documentation when the assembler is up and running but for the moment assume it is non-functional.

Some notes about MIPS_1:
	- Registers
		- 32 32-bit General Purpose Registers
		- $0 - hardwired to zero
		- HI/LO - 32-bit registers used for asynchronous int mul/div
		- PC

	- Instruction Formats:
		- R type : Opcode[0:5], rs[6:10], rt[11:15], rd[16:20], shamt[21:25], funct[26:31] 
		- I type : Opcode[0:5], rs[6:10], rt[11:15], immediate[16:31]
		- J type : Opcode[0:5], Address[6:31]

	- Instruction Details
		- Single point uses .s suffix
		- Double uses .d suffix
	
		- Load/Store
			- 8-bit, 16-bit and 32-bit
			- 
		- Add/Sub
			- Source operands from RS and RT
			- Output into RD
			
		- Mul/Div 
			- Signed or Unsigned
			- Output to HI/LOW 

		- Control Flow
			- Followed by branch delay slot
			- Compare RS against zero or RT

		-System Call, Breakpoint
			- call exceptions

	
		