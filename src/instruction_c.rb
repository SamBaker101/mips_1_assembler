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
    @mem

    def initialize(array, mem)
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
        @mem = mem
        @size = 32
    end

    def is_reg(operand)
        return (operand.nil? || !(operand[0].match(/[$rR]/))) ? 0 : 1
    end

    def print_line(array)
        print "Handling instruction: "
        array.each do |value|
            print "#{value} "
        end
        puts " "
    end
    
    def decode_operation()
        index = $INSTRUCTION_INDEX.find_index(@input[0].upcase)
        if (index != nil)
            @type           = $INSTRUCTION_MAP[index][1]        
            @opcode         = $INSTRUCTION_MAP[index][2]  
            @funct          = $INSTRUCTION_MAP[index][3]             
            @manual_args    = $INSTRUCTION_MAP[index][4].to_i
        else
            case(@input[0].upcase)
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
                    if (@input[1].nil?)
                        @address = "00000000000000000000001100"
                    else    
                        @address = @input[1] + "001100"
                    end
                    @manual_args = 1;
                
                when "SYSCALL"
                    #SYSCALL                     : Defined by OS
                    @type   = "J"
                    @opcode = "000000"
                    if (@input[1].nil?)
                        @address = "00000000000000000000001100"
                    else    
                        @address = @input[1] + "001100"
                    end
                    @manual_args = 1;
                
                else
                    abort "No op found for #{@input[0]}"
            end
        end
    end
    
    def decode_reg(string)
        if (string.chars[0] != "$")
            abort("Incorrect register token: #{string} does not start with $")
        elsif (string.chars[1].match(/(0-9)/))
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
                if (string[2].downcase == "p")
                    return binary_encode(29, 5)
                else
                    return binary_encode(string[2..-1].to_i + 16, 5)
                end
            when "k"
                return binary_encode(string[2..-1].to_i + 26, 5)
            when ("g")
                return "11100"
            when ("f")
                return "11110"
            when ("r")
                if (string[2] == "0")
                    return "00000"
                else
                    return "11111"
                end
            when ("0")
                return "00000"
            else 
                abort("Unrecognized register encoding #{string}")
            end
    end
    
    def encode(label_q, line_num)
        @input.each_with_index do |value, i|
            next if (i == 0)
            if (label_q[@input[i]] != nil)
                if ["BEQ", "BNE", "BGEZ"].include?(@input[0].upcase)
                    @input[i] = binary_encode((label_q[@input[i]].to_i(16) - @mem.get_pointer)/4 - 1, 16)
                else    
                    @input[i] = label_q[@input[i]]
                end
            end
        end 

        case(@type)
            when "R"
                if (@manual_args == 0)
                    @rd = decode_reg(@input[1])
                    if ['SLL', 'SRA'].include?(@input[0].upcase)
                        @rs = "00000" 
                        @rt = decode_reg(@input[-2])
                        @shamt = detect_format_and_convert(@input[-1], 5)
                    elsif ['SLLV', 'SRAV'].include?(@input[0].upcase)
                        @rs = decode_reg(@input[3])
                        @rt = decode_reg(@input[2])
                    elsif ['MFHI', 'MFLO'].include?(@input[0].upcase)
                        @rs = "00000"
                        @rt = "00000"    
                    elsif ['MULT', 'MULTU'].include?(@input[0].upcase)
                        @rs = decode_reg(@input[-2])
                        @rt = decode_reg(@input[-1]) 
                        @rd = "00000"
                    elsif ['JR', 'JAL', 'JALR'].include?(@input[0].upcase)
                        @rt = "00000"
                        @rd = "00000"
                        @rs = decode_reg(@input[-1])
                        @shamt = "00000"
                    else
                        @rs = decode_reg(@input[-2])
                        @rt = decode_reg(@input[-1])
                    end
                end

                @bin_output = @opcode + 
                        @rs + 
                        @rt + 
                        @rd + 
                        @shamt + 
                        @funct
                
            when "I"
                if (@manual_args == 0)
                    if ["BNE", "BEQ"].include?(@input[0].upcase)
                        @rs = decode_reg(@input[1])
                        @rt = decode_reg(@input[2])
                    elsif ["BGEZ"].include?(@input[0].upcase)
                        @rt = "00001" 
                        @rs = decode_reg(@input[1])
                    else
                        @rt = decode_reg(@input[1])
                        @rs = "00000"
                        if (@input.size == 4) 
                            @rs = decode_reg(@input[2])
                        end
                    end
                    temp = @input[-1].split("\(")
                    if (temp.length > 1)
                        @rs = decode_reg(temp[1].chomp("\)"))
                    end
                    
                    if (temp[0] == "")
                       @immediate = "0000000000000000"
                    else
                        if (temp[0][0] != '0')
                            temp[0] = temp[0]
                        end
                        @immediate = detect_format_and_convert(temp[0], 16)
                    end

                end
    
                @bin_output = @opcode + 
                        @rs + 
                        @rt + 
                        @immediate
    
            when "J"
                if (@manual_args == 0)
                    @input[-1].chomp!
                    @address = detect_format_and_convert(@input[-1], 28)[0..-3]
                end
                
                @bin_output = @opcode + 
                        @address

            else
                puts "Instruction Type not found : #{@type}"
                bin_output = @opcode + @address 
        end
    end

    def read(label_q, line_num)
        if (is_directive == 1)
            puts "SKIPPING DIRECTIVE #{@input[0]}"
        else
            decode_operation()
            encode(label_q, line_num)
            @hex_output = binary_to_hex(@bin_output);
    
            pack_mem()
        end
        return nil
    end

end
