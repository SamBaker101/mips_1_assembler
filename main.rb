# Sam Baker 09/2024
# MIPS_1 Assembler
####################
#!/usr/bin/env/ruby

IN = "samples/sample1.asm"
OUT = "output/out.txt"

COMMENT_CHARACTER   = "#"
HEX_OUT             = 1

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
    :manual_args
)

module Mode
    DATA = 0
    RDATA = 1
    SDATA = 2
    TEXT = 3
end

def main()
    in_file = File.new(IN, "r")
    out_file = File.new(OUT, "w")
    
    mode = Mode::TEXT

    read_q  = []
    inst_q  = []
    label_q = []
    
    total_lines = 0
    line_num = 0
    
    while (line = in_file.gets)
        total_lines += 1
        read_q.push(line)
    end
        
    puts "Total lines = " << total_lines.to_s
    
    while (line_num < total_lines) 
        array = read_q[line_num].split("\s"||",")
        line_num += 1
    
        next if (array[0].nil?)
        next if (array[0].chars.first == COMMENT_CHARACTER) 
    
        array.each_with_index do |value, index|
            if (value.chars.first == COMMENT_CHARACTER)
                array = array[0, index]
            end
        end

        if (array[0].chars.first == "\.")
            mode = decode_section_label(array[0].downcase)
            next
        end

        case (mode) 
            when Mode::DATA 
                #FIXME: capture data section inputs
            when Mode::RDATA 
                #FIXME: capture data section inputs
            when Mode::SDATA 
                #FIXME: capture data section inputs
            when Mode::TEXT 
                print_instruction(array)
                inst_out = read_instruction(array)
        end
    
        #puts "Adding inst to out " << inst_out
        inst_q.push(inst_out)
        out_file.puts(inst_out)
    end
    
    puts "Finishing"
    
    in_file.close
    out_file.close
end

def read_instruction(array)
    working_inst = init_instruction()
    working_inst = decode_operation(array, working_inst)
    inst_out = encode_working_inst(working_inst, array)

    if (HEX_OUT)
        inst_out = binary_to_hex(inst_out);
    end
end

def init_instruction()
    default = Instruction.new(
        nil,
        "000000",
        "00000",
        "00000",
        "00000",
        "00000",
        "000000",
        "0000000000000000",
        "00000000000000000000000000",
        0 
    )
end

def print_instruction(array)
    print "Handling instruction: "
    array.each do |value|
        print "#{value} "
    end
    puts " "
end

def decode_reg(string)
    
    if (string.chars[0] != "$")
        abort("Incorrect register token: #{string} does not start with $")
    end
    if (string.chars[1].match(/(0-9)/))
        return binary_encode(string[1..-1].to_i, 5)
    end 
    case (string[1].downcase)
        when ("z")
            return "00000"
        when "a"
            if (string[2] == "t")
                return  "00001"
            else
                return binary_encode(string[2..-1].to_i + 4, 5) 
            end
        when "v"
            return binary_encode(string[2..-1].to_i + 2, 5) 
        when "t"
            if (string[2..-1].to_i < 8)
                return binary_encode(string[2..-1].to_i + 8, 5) 
            else
                return binary_encode(string[2..-1].to_i + 24, 5) 
            end    
        when "s"
            return binary_encode(string[2..-1].to_i + 16, 5)
        when "k"
            return binary_encode(string[2..-1].to_i + 26, 5)
        when ("g")
            return "11100"
        when ("s")
            return "11101"
        when ("f")
            return "11110"
        when ("r")
            if (string[2] == "0")
                return "00000"
            else
                return "11111"
            end
        else 
            abort("Unrecognized register encoding #{string}")
        end
end

def decode_operation(array, working_inst)
    case(array[0].upcase)
        when "ADD"
        #ADD    rd, rs, rt          : Addition (with overflow)
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100000" 

        when "ADDI"
        #ADDI   rd, rs, Imm         : Addition immediate (with overflow)
            working_inst.type   = "I"
            working_inst.opcode = "001000" 

        when "ADDU"
        #ADDU   rd, rs, rt          : Addition (without overflow)
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100001"
        
        when "ADDIU"
        #ADDIU  rd, rs, Imm         : Addition immediate (without overflow)
            working_inst.type   = "I"
            working_inst.opcode = "001001"

        when "AND"
        #AND    rd, rs, rt          : AND
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100100"
        
        when "ANDI"
        #ANDI   rd, rs, Imm         : AND Immediate
            working_inst.type   = "I"
            working_inst.opcode = "001100"

        when "DIV"
        #DIV    rs, rt              : Divide(with overflow)
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "011010"
        
        when "DIVU"
        #DIVU   rs, rt              : Divide(without overflow)
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "011011"

        when "MULT"
        #MULT   rs, rt              : Multiply
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "011000"
        
        when "MULTU"
        #MULTU  rs, rt              : Unsigned Multiply
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "011001"

        when "NOR"
        #NOR    rd, rs, rt          : NOR
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100111"
        
        when "OR"
        #OR     rd, rs, rt          : OR
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100101"
        
        when "ORI"
        #ORI    rd, rs, tr          : OR Immediate
            working_inst.type   = "I"
            working_inst.opcode = "000000"

        when "SLL"
        #SLL    rd, rs, rt          : Shift Left Logical
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "000000"
        
        when "SLLV"
        #SLLV   rd, rs, rt          : Shift Left Logical Variable
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "000100"
        
        when "SRA"
        #SRA    rd, rs, rt          : Shift Right Arithmetic
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "000011"
        
        when "SRAV"
        #SRAV   rd, rs, rt          : Shift Right Arithmetic Variable
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "000111"
        
        when "SRL"
        #SRL    rd, rs, rt          : Shift Right Logical
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "000010"

        when "SRLV"
        #SRLV   rd, rs, rt          : Shift Right Logical Variable
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "000110"

        when "SUB"
        #SUB    rd, rs, rt          : Subtract (with overflow)
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100010"
        
        when "SUBU"
        #SUBU   rd, rs, rt          : Subtract (without overflow)
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100011"

        when "XOR"
        #XOR    rd, rs, rt          : XOR
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "100110"
        
        when "XORI"
        #XORI   rd, rs, Imm         : XOR Immediate
            working_inst.type   = "I"
            working_inst.opcode = "001110"

        when "LUI"
        #LUI    rd, Imm             : Load Upper Immediate
            working_inst.type   = "I"
            working_inst.opcode = "001111"

        when "SLT"
        #SLT    rd, rs, rt          : Set Less Than
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "101010"
        
        when "SLTI"
        #SLTI   rd, rt, Imm         : Set Less Than Immediate
            working_inst.type   = "I"
            working_inst.opcode = "001010"
        
        when "SLTU"
        #SLTU   rd, rs, rt          : Set Less Than Unsigned
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "101001"
        
        when "SLTIU"
        #SLTIU  rd, rs, Imm         : Set Less Than Unsigned Immediate
            working_inst.type   = "I"
            working_inst.opcode = "001001"

        when "BEQ"
        #BEQ    rs, rt, offset      : Branch on Equal
            working_inst.type   = "I"
            working_inst.opcode = "000100"
        
        when "BGEZ"
        #BGEZ   rs, offset          : Branch on Greater Than Equal Zero
            working_inst.type   = "I"
            working_inst.opcode = "000001"
        
        when "BGEZAL"
        #BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
            working_inst.type   = "I"
            working_inst.opcode = "000001"
        
        when "BGTZ"
        #BGTZ   rs, offset          : Branch on Greater Than Zero
            working_inst.type   = "I"
            working_inst.opcode = "000111"
        
        when "BLEZ"
        #BLEZ   rs, offset          : Branch on Less Than Equal Zero
            working_inst.type   = "I"
            working_inst.opcode = "000110"
        
        when "BLTZAL"
        #BLTZAL rs, offset          : Branch on Less Than And Link
            working_inst.type   = "I"
            working_inst.opcode = "000001"

        when "BLTZ"
        #BLTZ   rs, offset          : Branch on Less Than Zero
            working_inst.type   = "I"
            working_inst.opcode = "000001"
        
        when "BNE"
        #BNE    rs, rt, offset      : Branch on Not Equal
            working_inst.type   = "I"
            working_inst.opcode = "000101"

        when "J"
        #J      label               : Jump
            working_inst.type   = "J"
            working_inst.opcode = "000010"
        
        when "JAL"
        #JAL    label               : Jump and Link
            working_inst.type   = "J"
            working_inst.opcode = "000011"
        
        when "JALR"
        #JALR   rs                  : Jump and Link Register
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "001001"

        when "JR"
        #JR     rs                  : Jump Register
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "001000"

        when "LB"
        #LB     rd, imm(rs)         : Load Byte
            working_inst.type   = "I"
            working_inst.opcode = "100000"
        
        when "LBU"
        #LBU    rd, imm(rs)         : Load Unsigned Byte
            working_inst.type   = "I"
            working_inst.opcode = "100100"

        when "LH"
        #LH     rd, imm(rs)         : Load Halfword
            working_inst.type   = "I"
            working_inst.opcode = "100001"
        
        when "LHU"
        #LHU    rd, imm(rs)         : Load Unsigned Halfword
            working_inst.type   = "I"
            working_inst.opcode = "100101"

        when "LW"      
        #LW     rd, imm(rs)         : Load Word
            working_inst.type   = "I"
            working_inst.opcode = "100011" 

        when "LWL" 
        #LWL    rd, imm(rs)         : Load Word Left
            working_inst.type   = "I"
            working_inst.opcode = "100010"
        
        when "LWR" 
        #LWR    rd, imm(rs)         : Load Word Right
            working_inst.type   = "I"
            working_inst.opcode = "100110"

        when "SB" 
        #SB     rs, imm(rt)         : Store Byte
            working_inst.type   = "I"
            working_inst.opcode = "101000"
        
        when "SH"
        #SH     rs, imm(rt)         : Store Halfword
            working_inst.type   = "I"
            working_inst.opcode = "101001"

        when "SW"
        #SW     rs, imm(rt)         : Store Word
            working_inst.type   = "I"
            working_inst.opcode = "101011" 

        when "SWL"
        #SWL    rs, imm(rt)         : Store Word Left
            working_inst.type   = "I"
            working_inst.opcode = "000000"
        
        when "SWR" 
        #SWR    rs, imm(rt)         : Store Word Right
            working_inst.type   = "I"
            working_inst.opcode = "000000"

        when "MFHI"
        #MFHI   rd                  : Move From hi
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "010000"
        
        when "MFLO" 
        #MFLO   rd                  : Move From lo
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "010010"

        when "MTHI"
        #MTHI   rd                  : Move To hi
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "010001"
        
        when "MTLO"
        #MTLO   rd                  : Move To low
            working_inst.type   = "R"
            working_inst.opcode = "000000"
            working_inst.funct  = "010011"
        
        when "CFCZ"
            #FIXME: Coprocessor control not implemented yet
        when "COPZ"
            #FIXME: Coprocessor control not implemented yet
        when "CTCZ"
            #FIXME: Coprocessor control not implemented yet
        when "LWCZ" 
            #FIXME: Coprocessor control not implemented yet
        when "SWCZ" 
            #FIXME: Coprocessor control not implemented yet
        when "MFCZ" 
            #FIXME: Coprocessor control not implemented yet
        when "MTCZ" 
            #FIXME: Coprocessor control not implemented yet
        when "BCZT"
            #FIXME: Coprocessor control not implemented yet    
        when "BCZF"
            #FIXME: Coprocessor control not implemented yet

        when "BREAK"
        #BREAK                     : Immediately transfer control to Exception Handles
            working_inst.type   = "J"
            working_inst.opcode = "000000"
            working_inst.address = array[1] + "001101"
            working_inst.manual_args = 1;
    
        when "SYSCALL"
            #BREAK                     : Immediately transfer control to Exception Handles
            working_inst.type   = "J"
            working_inst.opcode = "000000"
            working_inst.address = array[1] + "001100"
            working_inst.manual_args = 1;

        else
            label_q[array[0]] = line_num
        
    end
    working_inst
end

def decode_section_label(label)
    case (label)
        when "\.data"
            mode = Mode::DATA
        when  "\.rdata"
            mode = Mode::RDATA
        when  "\.sdata"
            mode = Mode::SDATA
        when  "\.text"
            mode = Mode::TEXT
        else
            abort("Unrecognized code section #{array[0]}")
    end
    mode
end

def encode_working_inst(working_inst, array)
    case(working_inst.type)
        when "R"
            if (working_inst.manual_args == 0)
                working_inst.rs = decode_reg(array[2])
                working_inst.rt = decode_reg(array[3])
                working_inst.rd = decode_reg(array[1])
                #puts "#{array[1]}, #{array[2]}, #{array[3]} : #{working_inst.rs}, #{working_inst.rt}, #{working_inst.rd}"
            end

            inst_out = working_inst.opcode + 
                    working_inst.rs + 
                    working_inst.rt + 
                    working_inst.rd + 
                    working_inst.shamt + 
                    working_inst.funct

        when "I"
            if (working_inst.manual_args == 0)
                working_inst.rt = decode_reg(array[1])
                if (array.size == 4) 
                    working_inst.rs = decode_reg(array[2])
                end
                temp = array[-1].split("\(")
                if (temp.length > 1)
                    working_inst.rs = decode_reg(temp[1].chomp("\)"))
                end
                working_inst.immediate = binary_encode(temp[0].to_i, 16)
            end
            #puts "#{array[1]}, #{array[2]} : #{working_inst.rs}, #{working_inst.rt}"
            #puts "#{array[2]} : #{working_inst.immediate}"

            inst_out = working_inst.opcode + 
                    working_inst.rs + 
                    working_inst.rt + 
                    working_inst.immediate

        when "J"
            if (working_inst.manual_args == 0)
                if (array[-1].match(/^[0-9]+/))
                    working_inst.address = binary_encode(array[-1].to_i, 26)
                elsif (label_q[array[-1]] != nil)
                    working_inst.address.binary_encode(label_q[array[-1]], 26)
                else
                    abort("Unable to locate address for: #{array[-1]}")
                end
            end

            inst_out = working_inst.opcode + 
                    working_inst.address

        else
            puts "Instruction Type not found : #{working_inst.type}"
            inst_out = line 
    end
    inst_out
end

def binary_encode(dec, bits = 32)
    binary = "0"
    (0..(bits-2)).each do
        binary += "0"
    end
    (0..(bits-1)).each do |n|
        if (dec != 0)
            if (dec % 2 == 1)
                binary[(bits-1)-n] = "1"
            end
            dec = dec/2
        end
    end
    binary
end

def binary_to_hex(binary, bits = 32)
    integer = binary.to_i(2);
    hex = integer.to_s(16)

    while (hex.length < (bits/4.0).ceil) do
        hex = "0" + hex
    end

    hex.downcase!
    #puts "#{binary} \t: #{integer} \t: #{hex}"
    hex
end


main()



