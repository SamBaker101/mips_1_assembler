#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Testfile
####################

#TODO: Randomize these tests where possible

#File list
require "./src/parse_c.rb"
require "./src/line_c.rb"
require "./src/instruction_c.rb"
require "./src/data_c.rb"
require "./src/mem_c.rb"

#Test files
require "./tests/test_parse.rb"
require "./tests/test_line.rb"
require "./tests/test_data.rb"
require "./tests/test_inst.rb"
require "./tests/test_mem.rb"

$COMMENT_CHARACTER   = "#"
$INST_OFFSET         = "0x00400000"

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

$test_array_random  = ["abcd", "33", "31", "Boop"]

def call_tests()
    #This runs a full assembly of the selected test file ($IN)
    parser = ParseC.new()
    parser.parse_file()
    #TODO: Replace parse_file with test_parse_file()
    #This will be more involved, does full assemble, set up compare between sample output and MARS output
    #test_parse_file() 

    dummy_mem = MemC.new($MEM_SIZE, $MEM_INST_OFFSET, $MEM_DATA_OFFSET, self)


    ### ParseC Tests ###
    test_load_all_maps(parser)
    test_fill_queues(parser)
    test_check_for_mode_update(parser)
    test_update_line_class(parser)

    ### LineC Tests ###
    line = LineC.new($test_array_random)
    test_get_array(line)
    test_set_get_output(line)
    #test_ascii_convert()
    test_detect_format_and_convert(line)
    test_binary_encode(line)
    test_binary_to_hex(line)
    test_is_directive()
    test_decode_directive_mode()
    test_check_for_labels()
    test_chop_comments()
    #test_pack_mem()

    ### InstructionC Tests ###
    inst = InstructionC.new($test_array_random, dummy_mem)
    test_is_reg(inst)
    test_decode_operation(inst)
    test_decode_reg(inst)
    test_encode(inst)

    ### DataC Tests ###
    test_get_size()
    test_check_for_mult()
    test_parse_mem_lanes()

    ### MEM Tests ###
    test_get_byte()
    test_set_byte()
    test_get_pointer()
    test_write_into_mem()
    test_align()
    test_set_pointer()
end
    
#### MISC ####

call_tests()










