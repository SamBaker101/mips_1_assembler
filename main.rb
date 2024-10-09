# Sam Baker 09/2024
# MIPS_1 Assembler
####################
#!/usr/bin/env/ruby

IN = "input/in.txt"
OUT = "output/out.txt"

COMMENT_CHARACTER = "#"

Instruction = Struct.new(
    :type       ,
    :opcode     ,
    :rs         ,
    :rt         ,
    :rd         ,
    :shamt      ,
    :funct      ,
    :immediate  ,
    :address    ,
)

puts "Starting"

in_file = File.new(IN, "r")
out_file = File.new(OUT, "w")

inst_q  = []
label_q = []

line_num = 0

while (line = in_file.gets)
    array = line.split("\s"||",")
    next if (array[0].nil?)

    line_num += 1
    next if (array[0].chars.first == COMMENT_CHARACTER) 

    working_inst = Instruction.new(
        nil,
        "000000",
        "00000",
        "00000",
        "00000",
        "00000",
        "000000",
        "0000000000000000",
        "00000000000000000000000000" 
    )

    case(array[0].upcase)

        when "ADD"
        #ADD    rd, rs, rt          : Addition (with overflow)
            working_inst.type   = "R"
            working_inst.opcode = "100000" 

        when "ADDI"
        #ADDI   rd, rs, Imm         : Addition immediate (with overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000" 

        when "ADDU"
        #ADDU   rd, rs, rt          : Addition (without overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "ADDIU"
        #ADDIU  rd, rs, Imm         : Addition immediate (without overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "AND"
        #AND    rd, rs, rt          : AND
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "ANDI"
        #ANDI   rd, rs, Imm         : AND Immediate
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "DIV"
        #DIV    rs, rt              : Divide(with overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "DIVU"
        #DIVU   rs, rt              : Divide(without overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "MULT"
        #MULT   rs, rt              : Multiply
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "MULTU"
        #MULTU  rs, rt              : Unsigned Multiply
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "NOR"
        #NOR    rd, rs, rt          : NOR
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "OR"
        #OR     rd, rs, rt          : OR
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "ORI"
        #ORI    rd, rs, tr          : OR Immediate
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "SLL"
        #SLL    rd, rs, rt          : Shift Left Logical
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SLLV"
        #SLLV   rd, rs, rt          : Shift Left Logical Variable
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SRA"
        #SRA    rd, rs, rt          : Shift Right Arithmetic
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SRAV"
        #SRAV   rd, rs, rt          : Shift Right Arithmetic Variable
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SRL"
        #SRL    rd, rs, rt          : Shift Right Logical
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SRLV"
        #SRLV   rd, rs, rt          : Shift Right Logical Variable
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "SUB"
        #SUB    rd, rs, rt          : Subtract (with overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SUBU"
        #SUBU   rd, rs, rt          : Subtract (without overflow)
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "XOR"
        #XOR    rd, rs, rt          : XOR
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "XORI"
        #XORI   rd, rs, Imm         : XOR Immediate
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "LUI"
        #LUI    rd, Imm             : Load Upper Immediate
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "SLT"
        #SLT    rd, rs, rt          : Set Less Than
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SLTI"
        #SLTI   rd, rt, Imm         : Set Less Than Immediate
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SLTU"
        #SLTU   rd, rs, rt          : Set Less Than Unsigned
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SLTIU"
        #SLTIU  rd, rs, Imm         : Set Less Than Unsigned Immediate
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "BCZT"
        #BCZT   label               : Branch Coprocessor z True
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BCZF"
        #BCZF   label               : Branch Coprocessor z False
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "BEQ"
        #BEQ    rs, rt, offset      : Branch on Equal
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BGEZ"
        #BGEZ   rs, offset          : Branch on Greater Than Equal Zero
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BGEZAL"
        #BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BGTZ"
        #BGTZ   rs, offset          : Branch on Greater Than Zero
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BLEZ"
        #BLEZ   rs, offset          : Branch on Less Than Equal Zero
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "BGEZAL"
        #BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BLTZAL"
        #BLTZAL rs, offset          : Branch on Less Than And Link
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "BLTZ"
        #BLTZ   rs, offset          : Branch on Less Than Zero
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "BNE"
        #BNE    rs, rt, offset      : Branch on Not Equal
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "J"
        #J      label               : Jump
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "JAL"
        #JAL    label               : Jump and Link
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "JALR"
        #JALR   rs                  : Jump and Link Register
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "JR"
        #JR     rs                  : Jump Register
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "LB"
        #LB     rd, imm(rs)         : Load Byte
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "LBU"
        #LBU    rd, imm(rs)         : Load Unsigned Byte
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "LH"
        #LH     rd, imm(rs)         : Load Halfword
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "LHU"
        #LHU    rd, imm(rs)         : Load Unsigned Halfword
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "LW"
        #LW     rd, imm(rs)         : Load Word
            working_inst.type   = "I"
            working_inst.opcode = "100011" 

        when "LWCZ"
        #LWCZ   rd, imm(rs)         : Load Word
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "LWL"
        #LWL    rd, imm(rs)         : Load Word Left
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "LWR"
        #LWR    rd, imm(rs)         : Load Word Right
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "SB"
        #SB     rs, imm(rt)         : Store Byte
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SH"
        #SH     rs, imm(rt)         : Store Halfword
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "SW"
        #SW     rs, imm(rt)         : Store Word
            working_inst.type   = "I"
            working_inst.opcode = "101011" 

        when "SWCZ"
        #SWCZ   rs, imm(rt)         : Store Word
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "SWL"
        #SWL    rs, imm(rt)         : Store Word Left
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "SWR"
        #SWR    rs, imm(rt)         : Store Word Right
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "MFHI"
        #MFHI   rd                  : Move From hi
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "MFLO"
        #MFLO   rd                  : Move From lo
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        when "MTHI"
        #MTHI   rd                  : Move To hi
            working_inst.type   = "0"
            working_inst.opcode = "000000"
        
        when "MTLO"
        #MTLO   rd                  : Move To low
            working_inst.type   = "0"
            working_inst.opcode = "000000"

        else
            label_q[array[0]] = line_num
        
        end

    case(working_inst.type)
        when "R"
            inst_out = working_inst.opcode + 
                       working_inst.rs + 
                       working_inst.rt + 
                       working_inst.rd + 
                       working_inst.shamt + 
                       working_inst.funct

        when "I"
            inst_out = working_inst.opcode + 
                       working_inst.rs + 
                       working_inst.rt + 
                       working_inst.immediate

        when "J"
            inst_out = working_inst.opcode + 
                       working_inst.address

        else
            puts "Instruction Type not found"
            inst_out = line 
    end
    
    inst_q.push(inst_out)

    out_file.puts(inst_out)
end



puts "Finishing"

in_file.close
out_file.close

