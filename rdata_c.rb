#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - RData Class Definitions
####################

class RDataC < LineC
    @offset  
    @size    
    @content 
    
    def initialize(array)
        @input      = array
        @offset     = "0x00000000"  
        @size       = "0x00000000"
        @content    = "0x00000000"
    end

    def read()
        puts "Data line read not initialized"
    end
end