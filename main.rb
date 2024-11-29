#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler
####################

require "./src/parse_c.rb"
require "./src/line_c.rb"
require "./src/instruction_c.rb"
require "./src/data_c.rb"

$FILE_NAME       = "sample1"
$INST_MAP_FILE  = "maps/instruction_map.csv"
$DIR_MAP_FILE   = "maps/directive_map.csv"
$MNE_MAP_FILE   = "maps/mnemonic_map.csv"   

$HEX_OUT             = 1
$INSTRUCTION_MAP     = []
$INSTRUCTION_INDEX   = []
$DIRECTIVE_MAP       = [] 
$DIRECTIVE_INDEX     = []
$MNEMONIC_MAP       = [] 
$MNEMONIC_INDEX     = []

#TODO: This should probably be its own class
$MEM_SIZE               = 1024
$MEM_INST_OFFSET        = 0
$MEM_INST_POINTER       = $MEM_INST_OFFSET

$MEM_DATA_OFFSET        = 0x00400000
$MEM_DATA_POINTER       = $MEM_DATA_OFFSET

$MEM_ARRAY              = Array.new($MEM_SIZE)


#TODO: Implement instruction mnemonics
#TODO: Add missing directives
#TODO: There is very little error/invalid arg checking
#TODO: Complete the rest of the unit tests


def main()
    parser = ParseC.new()
    parser.parse_file()
end

main()


