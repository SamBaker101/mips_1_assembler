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
    #test_parse_input()     these will be part of test_parse_file
    #test_print_to_file()   these will be part of test_parse_file
    #test_print_labels()    these will be part of test_parse_file
    #test_close_files()     these will be part of test_parse_file

    ### LineC Tests ###
    line = LineC.new($test_array_random)
    test_get_array(line)
    test_set_get_output(line)
    test_detect_format_and_convert(line)
    test_binary_encode(line)
    test_binary_to_hex(line)
    test_is_directive()
    test_decode_directive_mode()
    test_check_for_labels()
    test_chop_comments()

    ### InstructionC Tests ###
    inst = InstructionC.new($test_array_random, dummy_mem)
    #test_read() - This is a parent function 
    test_is_reg(inst)
    #test_print_line(inst) - Print doesnt really need test
    test_decode_operation(inst)
    test_decode_reg(inst)
    test_encode(inst)

    ### DataC Tests ###
    test_get_size()
    test_check_for_mult()
    test_parse_mem_lanes()
    test_pack_mem()
    test_read()

    ### RDataC Tests ###

end

    ### ParseC Tests ###
    #parse_file()
    def test_parse_file()
        puts "Test not implemented: test_parse_file("
    end    

    #load_all_maps()
    #load_map(map_path, map, index)
def test_load_all_maps(parser)
    parser.load_all_maps()
    if ($INSTRUCTION_MAP[0][0] != "ADD")
        abort("ERROR: #{__method__.to_s}, $INSTRUCTION_MAP[0][0] = #{$INSTRUCTION_MAP[0][0]}")
    elsif ($DIRECTIVE_MAP[0][0] != ".text")
        abort("ERROR: #{__method__.to_s}, $DIRECTIVE_MAP[0][0] = #{$DIRECTIVE_MAP[0][0]}")
    elsif ($MNEMONIC_MAP[0][0] != "MOVE")
        abort("ERROR: #{__method__.to_s}, $MNEMONIC_MAP[0][0] = #{$MNEMONIC_MAP[0][0]}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end
end
    
    #fill_queues()
def test_fill_queues(parser)
    parser.fill_queues(File.new("samples/#{$FILE_NAME}.asm", "r"))
    if (parser.get_from_read_q(0).chomp != ".data")
        abort("ERROR: #{__method__.to_s}, read_q[0] = #{parser.get_from_read_q(0)}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end

end

    #check_for_mode_update(line_for_check)
def test_check_for_mode_update(parser)
    mode_list = [[".text"], [".rdata"], [".data"], [".lit4"], [".lit8"], [".bss"], [".sdata"], [".sbss"]]
    (0..(mode_list.size() - 1)).each do |n|
        line = LineC.new(mode_list[n])
        parser.check_for_mode_update(line)
        if (parser.get_mode() != n)
            abort("ERROR: #{__method__.to_s}, expected = #{n}:#{mode_list[n]}, got #{parser.get_mode()}")
        end
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

    #update_line_class(array, mode)
def test_update_line_class(parser)
    class_list = ["InstructionC", "DataC", "DataC"]
    (0..(class_list.size() - 1)).each do |n|
        line = LineC.new($test_array_random)
        line = parser.update_line_class($test_array_random, n)
        if (line.class().to_s != class_list[n])
            abort("ERROR: #{__method__.to_s}, expected = #{n}:#{class_list[n]}, got #{line.class()}")
        end
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

#### class LineC ####

#    def get_array()
def test_get_array(line)
    output_array = line.get_array()
    if (output_array != $test_array_random)
        abort("ERROR: #{__method__.to_s} error, input = #{$test_array_random}, out= #{output_array}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
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
        abort("ERROR: #{__method__.to_s} error, input = #{test_output_bin}:#{test_output_hex}, out= #{output}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
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
        abort("ERROR: #{__method__.to_s} - hex, input = #{hex}:#{bin}, out= #{hex2bin}")
    end

    dec2bin = line.detect_format_and_convert(dec)
    if (dec2bin != bin)
        abort("ERROR: #{__method__.to_s} - dec, input = #{dec}:#{bin}, out= #{dec2bin}")
    end

    bin2bin = line.detect_format_and_convert(bin)
    if (bin2bin != bin)
        abort("ERROR: #{__method__.to_s} - bin, input = #{bin}:#{bin}, out= #{bin2bin}")
    end

    oct2bin = line.detect_format_and_convert(oct)
    if (oct2bin != bin)
        abort("ERROR: #{__method__.to_s} - oct, input = #{oct}:#{bin}, out= #{oct2bin}")
    end

    puts "TEST: #{__method__.to_s}: Completed Successfully"
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
        abort("ERROR: #{__method__.to_s}, input = #{dec}, out= #{bin}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end
end

#   def binary_to_hex(binary, bits = 32)
def test_binary_to_hex(line)
    hex = "8c0a002d"
    bin = (hex.to_i(16)).to_s(2)
    output = line.binary_to_hex(bin)
    if (output != hex)
        abort("ERROR: #{__method__.to_s}, input = #{bin}, out= #{hex}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end
end

#   def is_section_label()
def test_is_directive()
    line = LineC.new(["rd", "t3", "10"])
    if (line.is_directive() != 0)
        abort(abort("ERROR: #{__method__.to_s}, input = #{line.get_array()}, out= 1"))
    end
    line = LineC.new([".rdata", "101011"])
    if (line.is_directive() != 1)
        abort(abort("ERROR: #{__method__.to_s}, input = #{line.get_array()}, out= 0"))
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

#   def is_empty()
def test_is_empty()
    line = LineC.new(["rd", "t3", "10"])
    if (line.is_empty() != 0)
        abort(abort("ERROR: #{__method__.to_s}, input = #{test_line.get_array()}, out= #{1}"))
    end
    line = LineC.new(["#This is a comment"])
    if (line.is_directive() != 1)
        abort(abort("ERROR: #{__method__.to_s}, input = #{test_line.get_array()}, out= #{1}"))
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end
    
#   def decode_directive()
def test_decode_directive_mode()    
    line = LineC.new([".data", "101011"])
    if (line.decode_directive_mode() != Mode::DATA)
        abort(abort("ERROR: #{__method__.to_s}, input = #{line.get_array()}"))
    end
    line = LineC.new([".rdata", "101011"])
    if (line.decode_directive_mode() != Mode::RDATA)
        abort(abort("ERROR: #{__method__.to_s}, input = #{line.get_array()}"))
    end
    line = LineC.new([".text", "101011"])
    if (line.decode_directive_mode() != Mode::TEXT)
        abort(abort("ERROR: #{__method__.to_s}, input = #{line.get_array()}"))
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

# check_for_labels
def test_check_for_labels()
    line = LineC.new(["test_label:"])
    if (line.check_for_labels() == 0);
        abort("ERROR: #{__method__.to_s} did not identify test label")
    end

    line = LineC.new($test_array_random)
    if (line.check_for_labels() != 0);
        abort("ERROR: #{__method__.to_s} identified non_label")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end
end

# chop_comments
def test_chop_comments()
    line = LineC.new(["a", "b", "#c", "d", "e"])
    line.chop_comments() 
    if (line.get_array().size != 2);
        abort("ERROR: #{__method__.to_s}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end
end

#### class InstructionC < LineC ####

#read()
def test_read()
    puts "Test not implemented: #{__method__.to_s}"
end

#is_reg(operand)
def test_is_reg(inst)
    if (inst.is_reg("addu") != 0)
        abort(abort("ERROR: #{__method__.to_s}, input = addu, out = #{1}"))
    end
    if (inst.is_reg("$at") == 0)
        abort(abort("ERROR: #{__method__.to_s}, input = $at, out= #{0}"))
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

#decode_operation()
def test_decode_operation(inst)
    puts "Test not implemented: #{__method__.to_s}"
end

#decode_reg(string)
def test_decode_reg(inst)
    puts "Test not implemented: #{__method__.to_s}"
end

#encode()
def test_encode(inst)
    puts "Test not implemented: #{__method__.to_s}"
end


#### class DataC < LineC ####
    
#   get_size(directive)
def test_get_size()
    puts "Test not implemented: #{__method__.to_s}"
end

#   check_for_mult()
def test_check_for_mult()
    puts "Test not implemented: #{__method__.to_s}"
end

#   parse_mem_lanes()
def test_parse_mem_lanes()
    puts "Test not implemented: #{__method__.to_s}"
end

#   pack_mem()
def test_pack_mem()
    puts "Test not implemented: #{__method__.to_s}"
end

#   read()
def test_read()
    puts "Test not implemented: #{__method__.to_s}"
end

#### MISC ####

call_tests()










