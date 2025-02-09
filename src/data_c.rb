#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Data Class Definitions
####################

#TODO: Labels for data items (variables)

class DataC < LineC
    @content 
    @output_array
    @mem

    def initialize(array, mem)
        @input      = array
        @offset     = "0x00000000"  
        @size       = 32
        @content    = "0x00000000"
        @output_array = []
        @mem        = mem
    end

    def get_size(directive)
        index = $DIRECTIVE_INDEX.find_index(directive)
        if ($DIRECTIVE_MAP[index][1] != "B")
            return -1
        else
            return $DIRECTIVE_MAP[index][2].to_i()
        end
        
    end        

    def check_for_mult()
        while (index = @input.find_index(":"))
            value = @input[index + 1]
            repeat = @input[index - 1].to_i()

            (index - 1 .. index + 1).each do |i|
                @input.delete_at(i)
            end
                        
            repeat.times {@input.insert(index - 1, value)}
        end
    end

    def parse_mem_lines()
        if (@input[0] == ".align")
            @mem.align(@input[1].to_i)
        elsif (@input[0] == ".space")
            (0..@input[1].to_i - 1).each do    
                @output_array.push("00")
            end
        else
            @input.each do |i|
                if i[0] == "."
                    @size = get_size(i)
                else
                    i = i.gsub(",","")
                    @bin_output = detect_format_and_convert(i, @size)
                    @hex_output = binary_to_hex(@bin_output, @size)
                    @output_array.push(get_output())
                end
            end
        end
    end

    def read(label_q, line_num)
        check_for_mult()
        parse_mem_lines()
        pack_mem()

        return nil
    end
end
