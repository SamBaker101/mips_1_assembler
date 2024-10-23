#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Testfile
####################

#File list
require "./bin/line_c.rb"
require "./bin/instruction_c.rb"
require "./bin/data_c.rb"

$COMMENT_CHARACTER   = "#"
$HEX_OUT             = 1

$test_array_random  = ["abcd", "33", 31, "Boop"]
$test_output_bin    = "10001100000010100000000000101101"
$test_output_hex    = "8c0a002d"

def call_tests()
    #List available test functions here
    line = LineC.new($test_array_random)
    test_get_array(line)
    test_set_get_output(line)

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
    line.set_output($test_output_bin)
    output = line.get_output()
    if (output != $test_output_hex)
        abort("ERROR: set_get_output error, input = #{$test_output_bin}:#{$test_output_hex}, out= #{output}")
    else
        puts "TEST: set_get_output(): Completed Successfully"
    end
end


#   def detect_format_and_convert(in)
#   def binary_encode(dec, bits = 32)    
#   def binary_to_hex(binary, bits = 32)

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










