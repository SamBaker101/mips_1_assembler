I have been tossing around the idea of implementing a MIPS1 chip similar to the R3000 (I have a lot of nostalgia for a certian grey box from the 90s). Additionally, it seems like the right complexity level to challenge me without becoming unmanagable. 

Unfortunately I haven't worked much with the MIPS_1 architecture directly so I wanted to try to create an assembler to familiarize myself with the ISA before diving into a larger project using it.

NOTE: 
	This project is still in progress. I am still working on some aspects and have more work to do to validate the outputs. I would recommend verifying any outputs against a proven simulator like MARS or SPIM  

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
		- Load/Store
			- 8-bit, 16-bit and 32-bit
			
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

Instruction List:
	ADD    rd, rs, rt          : Addition (with overflow)
	ADDI   rd, rs, Imm         : Addition immediate (with overflow)
	ADDU   rd, rs, rt          : Addition (without overflow)
	ADDIU  rd, rs, Imm         : Addition immediate (without overflow)	
	AND    rd, rs, rt          : AND
	ANDI   rd, rs, Imm         : AND Immediate	
	DIV    rs, rt              : Divide(with overflow)
	DIVU   rs, rt              : Divide(without overflow)	
	MULT   rs, rt              : Multiply
	MULTU  rs, rt              : Unsigned Multiply	
	NOR    rd, rs, rt          : NOR	
	OR     rd, rs, rt          : OR
	ORI    rd, rs, tr          : OR Immediate	
	SLL    rd, rs, rt          : Shift Left Logical
	SLLV   rd, rs, rt          : Shift Left Logical Variable
	SRA    rd, rs, rt          : Shift Right Arithmetic
	SRAV   rd, rs, rt          : Shift Right Arithmetic Variable
	SR1    rd, rs, rt          : Shift Right Logical
	SR1V   rd, rs, rt          : Shift Right Logical Variable	
	SUB    rd, rs, rt          : Subtract (with overflow)
	SUBU   rd, rs, rt          : Subtract (without overflow)	
	XOR    rd, rs, rt          : XOR
	XORI   rd, rs, Imm         : XOR Immediate	
	LUI    rd, Imm             : Load Upper Immediate	
	SLT    rd, rs, rt          : Set Less Than
	SLTI   rd, rt, Imm         : Set Less Than Immediate
	SLTU   rd, rs, rt          : Set Less Than Unsigned
	SLTIU  rd, rs, Imm         : Set Less Than Unsigned Immediate	
	BCZT   label               : Branch Coprocessor z True
	BCZF   label               : Branch Coprocessor z False	
	BEQ    rs, rt, offset      : Branch on Equal
	BGEZ   rs, offset          : Branch on Greater Than Equal Zero
	BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
	BGTZ   rs, offset          : Branch on Greater Than Zero
	BLEZ   rs, offset          : Branch on Less Than Equal Zero	
	BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
	BLTZAL rs, offset          : Branch on Less Than And Link	
	BLTZ   rs, offset          : Branch on Less Than Zero
	BNE    rs, rt, offset      : Branch on Not Equal	
	J      label               : Jump
	JAL    label               : Jump and Link
	JALR   rs                  : Jump and Link Register	
	JR     rs                  : Jump Register	
	LB     rd, imm(rs)         : Load Byte
	LBU    rd, imm(rs)         : Load Unsigned Byte	
	LH     rd, imm(rs)         : Load Halfword
	LHU    rd, imm(rs)         : Load Unsigned Halfword	
	LW     rd, imm(rs)         : Load Word
	LWCZ   rd, imm(rs)         : Load Word	
	LWL    rd, imm(rs)         : Load Word Left
	LWR    rd, imm(rs)         : Load Word Right	
	SB     rs, imm(rt)         : Store Byte
	SH     rs, imm(rt)         : Store Halfword	
	SW     rs, imm(rt)         : Store Word
	SWCZ   rs, imm(rt)         : Store Word	
	SWL    rs, imm(rt)         : Store Word Left
	SWR    rs, imm(rt)         : Store Word Right	
	MFHI   rd                  : Move From hi
	MFLO   rd                  : Move From lo
	
	MTHI   rd                  : Move To hi
	MTLO   rd                  : Move To low	

Resources Used:
		https://user.eng.umd.edu/~manoj/759M/MIPSALM.html
		https://shawnzhong.github.io/JsSpim/
		https://uweb.engr.arizona.edu/~ece369/Resources/spim/MIPSReference.pdf
		https://bh-cookbook.github.io/mips-asm/mips-instruction-set-part-5.html
		https://computerscience.missouristate.edu/mars-mips-simulator.htm
