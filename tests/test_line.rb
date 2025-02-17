#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Line Tests
####################

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

#   def ascii_convert
def test_ascii_convert()
    puts "Test not implemented: #{__method__.to_s}"
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

#   def pack_mem
def test_pack_mem()
    puts "Test not implemented: #{__method__.to_s}"
end
