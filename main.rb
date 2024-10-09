# Sam Baker 09/2024
# MIPS_1 Assembler
####################
#!/usr/bin/env/ruby

IN = "input/in.txt"
OUT = "output/out.txt"

COMMENT_CHARACTER = "#"

Instruction = Struct.new(
    :type,
    :opcode,
    :rs,
    :rt,
    :rd,
    :shamt,
    :funct,
    :immediate,
    :address
)

puts "Starting"

in_file = File.new(IN, "r")
out_file = File.new(OUT, "w")

inst_queue = []

while (line = in_file.gets)
    array = line.split("\s"||",")
    next if (array[0].nil?)
    next if (array[0].chars.first == COMMENT_CHARACTER) 

    working_inst = Instruction.new

    case(array[0])
        when "lw"
            working_inst.type = "I"
            working_inst.opcode = "10_0011" 
        end

    case(working_inst.type)
    when "I"
        inst_out = working_inst.opcode #FIXME: 

    else
        puts "Instruction Type not found"
        inst_out = line 
    end
    inst_queue.push(inst_out)

    out_file.puts(inst_out)
end



puts "Finishing"

in_file.close
out_file.close

#ALU
#ADD    rd, rs, rt          : Addition (with overflow)
#ADDI   rd, rs, Imm         : Addition immediate (with overflow)
#ADDU   rd, rs, rt          : Addition (without overflow)
#ADDIU  rd, rs, Imm         : Addition immediate (without overflow)

#AND    rd, rs, rt          : AND
#ANDI   rd, rs, Imm         : AND Immediate

#DIV    rs, rt              : Divide(with overflow)
#DIVU   rs, rt              : Divide(without overflow)

#MULT   rs, rt              : Multiply
#MULTU  rs, rt              : Unsigned Multiply

#NOR    rd, rs, rt          : NOR

#OR     rd, rs, rt          : OR
#ORI    rd, rs, tr          : OR Immediate

#SLL    rd, rs, rt          : Shift Left Logical
#SLLV   rd, rs, rt          : Shift Left Logical Variable
#SRA    rd, rs, rt          : Shift Right Arithmetic
#SRAV   rd, rs, rt          : Shift Right Arithmetic Variable
#SR1    rd, rs, rt          : Shift Right Logical
#SR1V   rd, rs, rt          : Shift Right Logical Variable

#SUB    rd, rs, rt          : Subtract (with overflow)
#SUBU   rd, rs, rt          : Subtract (without overflow)

#XOR    rd, rs, rt          : XOR
#XORI   rd, rs, Imm         : XOR Immediate

#LUI    rd, Imm             : Load Upper Immediate

#SLT    rd, rs, rt          : Set Less Than
#SLTI   rd, rt, Imm         : Set Less Than Immediate
#SLTU   rd, rs, rt          : Set Less Than Unsigned
#SLTIU  rd, rs, Imm         : Set Less Than Unsigned Immediate

#BCZT   label               : Branch Coprocessor z True
#BCZF   label               : Branch Coprocessor z False

#BEQ    rs, rt, offset      : Branch on Equal
#BGEZ   rs, offset          : Branch on Greater Than Equal Zero
#BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
#BGTZ   rs, offset          : Branch on Greater Than Zero
#BLEZ   rs, offset          : Branch on Less Than Equal Zero

#BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
#BLTZAL rs, offset          : Branch on Less Than And Link

#BLTZ   rs, offset          : Branch on Less Than Zero
#BNE    rs, rt, offset      : Branch on Not Equal

#J      label               : Jump
#JAL    label               : Jump and Link
#JALR   rs                  : Jump and Link Register

#JR     rs                  : Jump Register

#LB     rd, imm(rs)         : Load Byte
#LBU    rd, imm(rs)         : Load Unsigned Byte

#LH     rd, imm(rs)         : Load Halfword
#LHU    rd, imm(rs)         : Load Unsigned Halfword

#LW     rd, imm(rs)         : Load Word
#LWCZ   rd, imm(rs)         : Load Word

#LWL    rd, imm(rs)         : Load Word Left
#LWR    rd, imm(rs)         : Load Word Right

#SB     rs, imm(rt)         : Store Byte
#SH     rs, imm(rt)         : Store Halfword

#SW     rs, imm(rt)         : Store Word
#SWCZ   rs, imm(rt)         : Store Word

#SWL    rs, imm(rt)         : Store Word Left
#SWR    rs, imm(rt)         : Store Word Right

#MFHI   rd                  : Move From hi
#MFLO   rd                  : Move From lo
                    
#MTHI   rd                  : Move To hi
#MTLO   rd                  : Move To low

