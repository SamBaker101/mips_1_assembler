#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler
####################

require "./src/parse_c.rb"
require "./src/line_c.rb"
require "./src/instruction_c.rb"
require "./src/data_c.rb"

$IN         = "samples/sample1.asm"
$INST_OUT   = "output/inst_out.txt"
$DATA_OUT   = "output/data_out.txt"
$INST_MAP_FILE  = "maps/instruction_map.csv"
$DIR_MAP_FILE   = "maps/directive_map.csv"

$HEX_OUT             = 1
$INSTRUCTION_MAP     = []
$INSTRUCTION_INDEX   = []
$DIRECTIVE_MAP       = [] 
$DIRECTIVE_INDEX     = []


#TODO: Add instruction mnemonics
#TODO: Add missing directives
#TODO: There is very little error/invalid arg checking
#TODO: Complete the rest of the unit tests

def main()
    parser = ParseC.new()
    parser.parse_file()
end



main()


