#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Testfile
####################

#TODO: Randomize these tests where possible

#File list
require "./bin/line_c.rb"
require "./bin/instruction_c.rb"
require "./bin/data_c.rb"

$COMMENT_CHARACTER   = "#"
$HEX_OUT             = 1

module Mode
    DATA = 0
    RDATA = 1
    TEXT = 2
end

$test_array_random  = ["abcd", "33", 31, "Boop"]

def call_tests()
    ### LineC Tests ###
    line = LineC.new($test_array_random)
    test_get_array(line)
    test_set_get_output(line)
    test_detect_format_and_convert(line)
    test_binary_encode(line)
    test_binary_to_hex(line)
    test_is_directive()
    test_decode_directive()

    ### InstructionC Tests ###

    ### DataC Tests ###

    ### RDataC Tests ###

end

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
        abort(abort("ERROR: is_directive, input = #{test_line.get_array()}, out= #{1}"))
    end
    line = LineC.new([".rdata", "101011"])
    if (line.is_directive() != 1)
        abort(abort("ERROR: is_directive, input = #{test_line.get_array()}, out= #{1}"))
    end
    puts "TEST: is_directive(): Completed Successfully"
end

#   def decode_directive()
def test_decode_directive()    
    line = LineC.new([".data", "101011"])
    if (line.decode_directive() != Mode::DATA)
        abort(abort("ERROR: decode_directive, input = #{test_line.get_array()}"))
    end
    line = LineC.new([".rdata", "101011"])
    if (line.decode_directive() != Mode::RDATA)
        abort(abort("ERROR: decode_directive, input = #{test_line.get_array()}"))
    end
    line = LineC.new([".text", "101011"])
    if (line.decode_directive() != Mode::TEXT)
        abort(abort("ERROR: decode_directive, input = #{test_line.get_array()}"))
    end
    puts "TEST: decode_directive(): Completed Successfully"
end

#   def is_empty()
#   def chop_comments()

#### class InstructionC < LineC ####

#   def read()
#   def print_line(array)
#   def decode_operation()
#   def decode_reg(string)
#   def encode()

#### class DataC < LineC ####
    
#   def initialize(array)

#### MISC ####

#   def decode_section_label(label)

call_tests()










