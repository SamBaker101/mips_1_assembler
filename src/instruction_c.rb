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
    end

    def read(label_q, line_num)
        print_line(@input)

        decode_operation()
        @bin_output = encode(label_q, line_num)
        @hex_output = binary_to_hex(@bin_output);
    
        pack_mem()
        return nil
    end

    def is_reg(operand)
        if (operand[0].match(/[$rR]/))
            return 1
        else
            return 0
        end
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
                    #BREAK                     : Immediately transfer control to Exception Handles
                    @type   = "J"
                    @opcode = "000000"
                    if (@input[1].nil?)
                        @address = "00000000000000000000001100"
                    else    
                        @address = @input[1] + "001100"
                    end
                    @manual_args = 1;
                
                else
                    puts "No op found for #{@input[0]}"
            end
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

    def encode(label_q, line_num)
        case(@type)
            when "R"
                if (@manual_args == 0)
                    @rs = decode_reg(@input[-2])
                    @rt = decode_reg(@input[-1])
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
                    @immediate = detect_format_and_convert(temp[0].to_i, 16)

                end
                #puts "#{@input[1]}, #{@input[2]} : #{@rs}, #{@rt}"
                #puts "#{@manual_args} : #{@input[-1]} : #{@immediate} : #{temp}"
    
                @bin_output = @opcode + 
                        @rs + 
                        @rt + 
                        @immediate
    
            when "J"
                if (@manual_args == 0)
                    if (@input[-1].match(/^[0-9]+/))
                        @address = detect_format_and_convert(@input[-1].to_i, 26)
                    else
                        @input[-1].chomp!
                        raw_address = label_q[@input[-1]]
                        @address = binary_encode(raw_address.to_i(16), 28)[0..-3]
                    end
                end
                
                @bin_output = @opcode + 
                        @address
            else
                puts "Instruction Type not found : #{@type}"
                bin_output = @opcode + @address 
        end
    end

    def pack_mem()
        pointer = @mem.get_pointer()
        item = @hex_output
        (item.size()/2).times do |j|
            index = item.size() - j*2 - 1
            @mem.set_byte(pointer, item[(index - 1) .. index])
            pointer += 1
        end
        @mem.set_pointer(pointer)
    end
end
