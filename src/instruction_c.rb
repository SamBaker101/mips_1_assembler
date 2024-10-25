#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Instruction Class Definitions
####################

class InstructionC < LineC
    @type          
    @opcode        
    @rs            
    @rt            
    @rd            
    @shamt         
    @funct         
    @immediate     
    @address       
    @manual_args   

    def initialize(array)
        @input = array
        @type          = nil
        @opcode        = "000000"
        @rs            = "00000"
        @rt            = "00000"
        @rd            = "00000"
        @shamt         = "00000"
        @funct         = "000000"
        @immediate     = "0000000000000000"
        @address       = "00000000000000000000000000"
        @manual_args   = 0
    end

    def read()
        self.print_line(@input)

        self.decode_operation()
        @bin_output = self.encode()
        @hex_output = binary_to_hex(@bin_output);
    end
    
    def print_line(array)
        print "Handling instruction: "
        array.each do |value|
            print "#{value} "
        end
        puts " "
    end
    
    def decode_operation()
        case(@input[0].upcase)
            when "ADD"
            #ADD    rd, rs, rt          : Addition (with overflow)
                @type   = "R"
                @opcode = "000000"
                @funct  = "100000" 
    
            when "ADDI"
            #ADDI   rd, rs, Imm         : Addition immediate (with overflow)
                @type   = "I"
                @opcode = "001000" 
    
            when "ADDU"
            #ADDU   rd, rs, rt          : Addition (without overflow)
                @type   = "R"
                @opcode = "000000"
                @funct  = "100001"
            
            when "ADDIU"
            #ADDIU  rd, rs, Imm         : Addition immediate (without overflow)
                @type   = "I"
                @opcode = "001001"
    
            when "AND"
            #AND    rd, rs, rt          : AND
                @type   = "R"
                @opcode = "000000"
                @funct  = "100100"
            
            when "ANDI"
            #ANDI   rd, rs, Imm         : AND Immediate
                @type   = "I"
                @opcode = "001100"
    
            when "DIV"
            #DIV    rs, rt              : Divide(with overflow)
                @type   = "R"
                @opcode = "000000"
                @funct  = "011010"
            
            when "DIVU"
            #DIVU   rs, rt              : Divide(without overflow)
                @type   = "R"
                @opcode = "000000"
                @funct  = "011011"
    
            when "MULT"
            #MULT   rs, rt              : Multiply
                @type   = "R"
                @opcode = "000000"
                @funct  = "011000"
            
            when "MULTU"
            #MULTU  rs, rt              : Unsigned Multiply
                @type   = "R"
                @opcode = "000000"
                @funct  = "011001"
    
            when "NOR"
            #NOR    rd, rs, rt          : NOR
                @type   = "R"
                @opcode = "000000"
                @funct  = "100111"
            
            when "OR"
            #OR     rd, rs, rt          : OR
                @type   = "R"
                @opcode = "000000"
                @funct  = "100101"
            
            when "ORI"
            #ORI    rd, rs, tr          : OR Immediate
                @type   = "I"
                @opcode = "000000"
    
            when "SLL"
            #SLL    rd, rs, rt          : Shift Left Logical
                @type   = "R"
                @opcode = "000000"
                @funct  = "000000"
            
            when "SLLV"
            #SLLV   rd, rs, rt          : Shift Left Logical Variable
                @type   = "R"
                @opcode = "000000"
                @funct  = "000100"
            
            when "SRA"
            #SRA    rd, rs, rt          : Shift Right Arithmetic
                @type   = "R"
                @opcode = "000000"
                @funct  = "000011"
            
            when "SRAV"
            #SRAV   rd, rs, rt          : Shift Right Arithmetic Variable
                @type   = "R"
                @opcode = "000000"
                @funct  = "000111"
            
            when "SRL"
            #SRL    rd, rs, rt          : Shift Right Logical
                @type   = "R"
                @opcode = "000000"
                @funct  = "000010"
    
            when "SRLV"
            #SRLV   rd, rs, rt          : Shift Right Logical Variable
                @type   = "R"
                @opcode = "000000"
                @funct  = "000110"
    
            when "SUB"
            #SUB    rd, rs, rt          : Subtract (with overflow)
                @type   = "R"
                @opcode = "000000"
                @funct  = "100010"
            
            when "SUBU"
            #SUBU   rd, rs, rt          : Subtract (without overflow)
                @type   = "R"
                @opcode = "000000"
                @funct  = "100011"
    
            when "XOR"
            #XOR    rd, rs, rt          : XOR
                @type   = "R"
                @opcode = "000000"
                @funct  = "100110"
            
            when "XORI"
            #XORI   rd, rs, Imm         : XOR Immediate
                @type   = "I"
                @opcode = "001110"
    
            when "LUI"
            #LUI    rd, Imm             : Load Upper Immediate
                @type   = "I"
                @opcode = "001111"
    
            when "SLT"
            #SLT    rd, rs, rt          : Set Less Than
                @type   = "R"
                @opcode = "000000"
                @funct  = "101010"
            
            when "SLTI"
            #SLTI   rd, rt, Imm         : Set Less Than Immediate
                @type   = "I"
                @opcode = "001010"
            
            when "SLTU"
            #SLTU   rd, rs, rt          : Set Less Than Unsigned
                @type   = "R"
                @opcode = "000000"
                @funct  = "101001"
            
            when "SLTIU"
            #SLTIU  rd, rs, Imm         : Set Less Than Unsigned Immediate
                @type   = "I"
                @opcode = "001001"
    
            when "BEQ"
            #BEQ    rs, rt, offset      : Branch on Equal
                @type   = "I"
                @opcode = "000100"
            
            when "BGEZ"
            #BGEZ   rs, offset          : Branch on Greater Than Equal Zero
                @type   = "I"
                @opcode = "000001"
            
            when "BGEZAL"
            #BGEZAL rs, offset          : Branch on Greater Than Equal Zero And Link
                @type   = "I"
                @opcode = "000001"
            
            when "BGTZ"
            #BGTZ   rs, offset          : Branch on Greater Than Zero
                @type   = "I"
                @opcode = "000111"
            
            when "BLEZ"
            #BLEZ   rs, offset          : Branch on Less Than Equal Zero
                @type   = "I"
                @opcode = "000110"
            
            when "BLTZAL"
            #BLTZAL rs, offset          : Branch on Less Than And Link
                @type   = "I"
                @opcode = "000001"
    
            when "BLTZ"
            #BLTZ   rs, offset          : Branch on Less Than Zero
                @type   = "I"
                @opcode = "000001"
            
            when "BNE"
            #BNE    rs, rt, offset      : Branch on Not Equal
                @type   = "I"
                @opcode = "000101"
    
            when "J"
            #J      label               : Jump
                @type   = "J"
                @opcode = "000010"
            
            when "JAL"
            #JAL    label               : Jump and Link
                @type   = "J"
                @opcode = "000011"
            
            when "JALR"
            #JALR   rs                  : Jump and Link Register
                @type   = "R"
                @opcode = "000000"
                @funct  = "001001"
    
            when "JR"
            #JR     rs                  : Jump Register
                @type   = "R"
                @opcode = "000000"
                @funct  = "001000"
    
            when "LB"
            #LB     rd, imm(rs)         : Load Byte
                @type   = "I"
                @opcode = "100000"
            
            when "LBU"
            #LBU    rd, imm(rs)         : Load Unsigned Byte
                @type   = "I"
                @opcode = "100100"
    
            when "LH"
            #LH     rd, imm(rs)         : Load Halfword
                @type   = "I"
                @opcode = "100001"
            
            when "LHU"
            #LHU    rd, imm(rs)         : Load Unsigned Halfword
                @type   = "I"
                @opcode = "100101"
    
            when "LW"      
            #LW     rd, imm(rs)         : Load Word
                @type   = "I"
                @opcode = "100011" 
    
            when "LWL" 
            #LWL    rd, imm(rs)         : Load Word Left
                @type   = "I"
                @opcode = "100010"
            
            when "LWR" 
            #LWR    rd, imm(rs)         : Load Word Right
                @type   = "I"
                @opcode = "100110"
    
            when "SB" 
            #SB     rs, imm(rt)         : Store Byte
                @type   = "I"
                @opcode = "101000"
            
            when "SH"
            #SH     rs, imm(rt)         : Store Halfword
                @type   = "I"
                @opcode = "101001"
    
            when "SW"
            #SW     rs, imm(rt)         : Store Word
                @type   = "I"
                @opcode = "101011" 
    
            when "SWL"
            #SWL    rs, imm(rt)         : Store Word Left
                @type   = "I"
                @opcode = "000000"
            
            when "SWR" 
            #SWR    rs, imm(rt)         : Store Word Right
                @type   = "I"
                @opcode = "000000"
    
            when "MFHI"
            #MFHI   rd                  : Move From hi
                @type   = "R"
                @opcode = "000000"
                @funct  = "010000"
            
            when "MFLO" 
            #MFLO   rd                  : Move From lo
                @type   = "R"
                @opcode = "000000"
                @funct  = "010010"
    
            when "MTHI"
            #MTHI   rd                  : Move To hi
                @type   = "R"
                @opcode = "000000"
                @funct  = "010001"
            
            when "MTLO"
            #MTLO   rd                  : Move To low
                @type   = "R"
                @opcode = "000000"
                @funct  = "010011"
            
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
                @type   = "J"
                @opcode = "000000"
                @address = @input[1] + "001101"
                @manual_args = 1;
        
            when "SYSCALL"
                #BREAK                     : Immediately transfer control to Exception Handles
                @type   = "J"
                @opcode = "000000"
                @address = @input[1] + "001100"
                @manual_args = 1;
    
            else
                label_q[@input[0]] = line_num
            
        end
    end
    
    def decode_reg(string)
        #puts "Decode: #{string}"
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

    def encode()
        case(@type)
            when "R"
                if (@manual_args == 0)
                    @rs = decode_reg(@input[2])
                    @rt = decode_reg(@input[3])
                    @rd = decode_reg(@input[1])
                    #puts "#{@input[1]}, #{@input[2]}, #{@input[3]} : #{@rs}, #{@rt}, #{@rd}"
                end
    
                @bin_output = @opcode + 
                        @rs + 
                        @rt + 
                        @rd + 
                        @shamt + 
                        @funct
    
            when "I"
                if (@manual_args == 0)
                    @rt = decode_reg(@input[1])
                    if (@input.size == 4) 
                        @rs = decode_reg(@input[2])
                    end
                    temp = @input[-1].split("\(")
                    if (temp.length > 1)
                        @rs = decode_reg(temp[1].chomp("\)"))
                    else
                        @rs = "00000"
                    end
                    @immediate = self.detect_format_and_convert(temp[0].to_i, 16)

                end
                #puts "#{@input[1]}, #{@input[2]} : #{@rs}, #{@rt}"
                #puts "#{@input[2]} : #{@immediate}"
    
                @bin_output = @opcode + 
                        @rs + 
                        @rt + 
                        @immediate
    
            when "J"
                if (@manual_args == 0)
                    if (@input[-1].match(/^[0-9]+/))
                        @address = self.detect_format_and_convert(@input[-1].to_i, 26)
                    end
                end
    
                @bin_output = @opcode + 
                        @address
    
            else
                puts "Instruction Type not found : #{@type}"
                bin_output = line 
        end
    end
end
