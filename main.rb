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
$MAP_FILE   = "maps/instruction_map.csv"

$HEX_OUT             = 1
$INSTRUCTION_MAP     = []
$INSTRUCTION_INDEX   = []

#TODO: Add instruction mnemonics
#TODO: Data sections
#TODO: Add missing directives

module Mode
    DATA = 0
    RDATA = 1
    TEXT = 2

end

def main()
    parser = ParseC.new()
    parser.fill_read_q()
    parser.parse_file()
end



main()


