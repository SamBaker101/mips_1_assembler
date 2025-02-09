#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler
####################

require "./src/parse_c.rb"
require "./src/line_c.rb"
require "./src/instruction_c.rb"
require "./src/data_c.rb"
require "./src/mem_c.rb"

$FILE_NAME       = "ascii2"
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

def main()
    input_array = ARGV
    if input_array[0]
        $FILE_NAME = input_array[0]
    end
    if input_array[1] == "B"
        $HEX_OUT = 0
    elsif input_array[1] == "H" 
        $HEX_OUT = 1
    end
    

    parser = ParseC.new()
    parser.parse_file()

    diff_file  = File.new("output/#{$FILE_NAME}_diff.txt", "w")
    diff_file.print(`diff #{"output/#{$FILE_NAME}_inst.txt"} #{"samples/MARS_outputs/#{$FILE_NAME}_mars_inst.txt"}`)
    diff_file.close()
end

main()


