#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Testfile
####################

#File list
require "./main.rb"

$test_array_random = ["abcd", "33", 31, "Boop"]


def call_tests()
    #List available test functions here
    test_get_array()


end

#### class LineC ####

#    def get_array()
def test_get_array()
    line = LineC.new($test_array_random)
    output_array = line.get_array()
    if (output_array != $test_array_random)
        abort("ERROR: get_array error, input = #{$test_array_random}, out= #{output_array}")
    else
        puts "TEST: get_array(): Completed Successfully"
    end
end

#    def get_output

#    def detect_format_and_convert(in)
#    def binary_encode(dec, bits = 32)    
#    def binary_to_hex(binary, bits = 32)

#### class InstructionC < LineC ####

#    def read()
#    def print_line(array)
#    def decode_operation()
#    def decode_reg(string)
#    def encode()

#### class DataC < LineC ####
    
#    def initialize(array)

#### MISC ####

#def decode_section_label(label)

call_tests()










