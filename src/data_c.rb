#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Data Class Definitions
####################

class DataC < LineC
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
            if ($DIRECTIVE_MAP[index][1] != "B")
                return -1
            else
                return $DIRECTIVE_MAP[index][2].to_i()
            end
        end
    end        

    def check_for_mult()
        #TODO: MARS doesn't appear to support this syntax, find out why
        while (index = @input.find_index(":"))
            value = @input[index + 1]
            repeat = @input[index - 1].to_i()

            @input.delete_at(index + 1)
            @input.delete_at(index)
            @input.delete_at(index - 1)
            
            repeat.times {@input.insert(index - 1, value)}
        end
    end

    def parse_mem_lines()
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
        check_for_mult()
        parse_mem_lines()
        #TODO: Do these values need to be packed in the output file?
        return @output_array
    end
end
