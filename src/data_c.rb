#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Data Class Definitions
####################

class DataC < LineC
    @offset  
    @size    
    @content 
    
    def initialize(array)
        @input      = array
        @offset     = "0x00000000"  
        @size       = "0x00000000"
        @content    = "0x00000000"
    end

    def read(label_q, line_num)
        puts "Data line read not initialized"
    end
end
