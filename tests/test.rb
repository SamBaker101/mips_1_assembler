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

$COMMENT_CHARACTER   = "#"
$HEX_OUT             = 1

$IN         = "samples/sample1.asm"
$INST_OUT   = "output/inst_out.txt"
$DATA_OUT   = "output/data_out.txt"
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

$test_array_random  = ["abcd", "33", 31, "Boop"]

def call_tests()
    #TODO: Should test the Parse class functions individually
    parser = ParseC.new()
    parser.parse_file()

    ### ParseC Tests ###
    test_load_all_maps()

    ### LineC Tests ###
    line = LineC.new($test_array_random)
    test_get_array(line)
    test_set_get_output(line)
    test_detect_format_and_convert(line)
    test_binary_encode(line)
    test_binary_to_hex(line)
    test_is_directive()
    test_decode_directive_mode()

    ### InstructionC Tests ###

    ### DataC Tests ###

    ### RDataC Tests ###

end

    ### ParseC Tests ###
    #load_all_maps()
    #load_map(map_path, map, index)
def test_load_all_maps()
    parser = ParseC.new()
    parser.load_all_maps()
    if ($INSTRUCTION_MAP[0][0] != "ADD")
        abort("ERROR: load_all_maps(), $INSTRUCTION_MAP[0][0] = #{$INSTRUCTION_MAP[0][0]}")
    elsif ($DIRECTIVE_MAP[0][0] != ".text")
        abort("ERROR: load_all_maps(), $DIRECTIVE_MAP[0][0] = #{$DIRECTIVE_MAP[0][0]}")
    elsif ($MNEMONIC_MAP[0][0] != "MOVE")
        abort("ERROR: load_all_maps(), $MNEMONIC_MAP[0][0] = #{$MNEMONIC_MAP[0][0]}")
    else
        puts "TEST: load_all_maps(): Completed Successfully"
    end
end

    
    #fill_queues()
    #check_for_mode_update(line_for_check)
    #update_line_class(array, mode)
    #parse_input()
    #print_to_file()
    #print_labels()
    #close_files()
    #parse_file()

#### class LineC ####

#    def get_array()
def test_get_array(line)
    output_array = line.get_array()
    if (output_array != $test_array_random)
        abort("ERROR: get_array error, input = #{$test_array_random}, out= #{output_array}")
    else
        puts "TEST: get_array(): Completed Successfully"
    end
end

#   def set_output  
#   def get_output
def test_set_get_output(line)
    test_output_bin    = "10001100000010100000000000101101"
    test_output_hex    = "8c0a002d"

    line.set_output(test_output_bin)
    output = line.get_output()
    if (output != test_output_hex)
        abort("ERROR: set_get_output error, input = #{test_output_bin}:#{test_output_hex}, out= #{output}")
    else
        puts "TEST: set_get_output(): Completed Successfully"
    end
end

#   def detect_format_and_convert(input)
def test_detect_format_and_convert(line)
    hex = "0x7bcd"
    dec = hex.to_i(16)
    bin = "0" + dec.to_s(2)
    oct = "00" + dec.to_s(8)
    
    hex2bin = line.detect_format_and_convert(hex)
    if (hex2bin != bin)
        abort("ERROR: detect_format_and_convert - hex, input = #{hex}:#{bin}, out= #{hex2bin}")
    end

    dec2bin = line.detect_format_and_convert(dec)
    if (dec2bin != bin)
        abort("ERROR: detect_format_and_convert - dec, input = #{dec}:#{bin}, out= #{dec2bin}")
    end

    bin2bin = line.detect_format_and_convert(bin)
    if (bin2bin != bin)
        abort("ERROR: detect_format_and_convert - bin, input = #{bin}:#{bin}, out= #{bin2bin}")
    end

    oct2bin = line.detect_format_and_convert(oct)
    if (oct2bin != bin)
        abort("ERROR: detect_format_and_convert - oct, input = #{oct}:#{bin}, out= #{oct2bin}")
    end

    puts "TEST: detect_format_and_convert: Completed Successfully"
end

#   def binary_encode(dec, bits = 32)    
def test_binary_encode(line)
    dec = 96549
    bin = dec.to_s(2)
    while (bin.length < 32) do
        bin = "0" + bin
    end
    output = line.binary_encode(dec)
    if (output != bin)
        abort("ERROR: binary_encode, input = #{dec}, out= #{bin}")
    else
        puts "TEST: binary_encode(): Completed Successfully"
    end
end

#   def binary_to_hex(binary, bits = 32)
def test_binary_to_hex(line)
    hex = "8c0a002d"
    bin = (hex.to_i(16)).to_s(2)
    output = line.binary_to_hex(bin)
    if (output != hex)
        abort("ERROR: binary_to_hex, input = #{bin}, out= #{hex}")
    else
        puts "TEST: binary_to_hex(): Completed Successfully"
    end
end

#   def is_section_label()
def test_is_directive()
    line = LineC.new(["rd", "t3", "10"])
    if (line.is_directive() != 0)
        abort(abort("ERROR: is_directive, input = #{line.get_array()}, out= 1"))
    end
    line = LineC.new([".rdata", "101011"])
    if (line.is_directive() != 1)
        abort(abort("ERROR: is_directive, input = #{line.get_array()}, out= 0"))
    end
    puts "TEST: is_directive(): Completed Successfully"
end

#   def is_empty()
def test_is_empty()
    line = LineC.new(["rd", "t3", "10"])
    if (line.is_empty() != 0)
        abort(abort("ERROR: is_empty, input = #{test_line.get_array()}, out= #{1}"))
    end
    line = LineC.new(["#This is a comment"])
    if (line.is_directive() != 1)
        abort(abort("ERROR: is_directive, input = #{test_line.get_array()}, out= #{1}"))
    end
    puts "TEST: is_directive(): Completed Successfully"
end
    

#   def decode_directive()
def test_decode_directive_mode()    
    line = LineC.new([".data", "101011"])
    if (line.decode_directive_mode() != Mode::DATA)
        abort(abort("ERROR: decode_directive, input = #{line.get_array()}"))
    end
    line = LineC.new([".rdata", "101011"])
    if (line.decode_directive_mode() != Mode::RDATA)
        abort(abort("ERROR: decode_directive, input = #{line.get_array()}"))
    end
    line = LineC.new([".text", "101011"])
    if (line.decode_directive_mode() != Mode::TEXT)
        abort(abort("ERROR: decode_directive, input = #{line.get_array()}"))
    end
    puts "TEST: decode_directive(): Completed Successfully"
end

# check_for_labels
# chop_comments


#   def chop_comments()

#### class InstructionC < LineC ####

#   def read()
#   def print_line(array)
#   def decode_operation()
#   def decode_reg(string)
#   def encode()

#### class DataC < LineC ####
    
#   get_size(directive)
#   check_for_mult()
#   parse_mem_lanes()
#   pack_mem()
#   read()

#### MISC ####

call_tests()










