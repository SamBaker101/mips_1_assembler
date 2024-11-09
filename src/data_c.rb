#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Data Class Definitions
####################

class DataC < LineC
    @offset  
    @size    
    @content 
    @output_array
    
    def initialize(array)
        @input      = array
        @offset     = "0x00000000"  
        @size       = 32
        @content    = "0x00000000"
        @output_array = []
    end

    def get_size(directive)
        if (directive[0] != ".")
            return -1
        else 
            index = $DIRECTIVE_INDEX.find_index(directive)
            return $DIRECTIVE_MAP[index][2].to_i()
        end
    end        

    def add_mem_lines()
        @input.each do |i|
            if i[0] == "."
                @size = get_size(i)
            else
                @bin_output = binary_encode(i.to_i(), @size)
                @hex_output = binary_to_hex(@bin_output, @size)
                @output_array.push(get_output())
            end
        end
    end

    def read(label_q, line_num)
        add_mem_lines()
        #TODO: Do these values need to be packed in the output file?
        return @output_array
    end
end
