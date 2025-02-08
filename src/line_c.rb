#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Line Class Definition
####################

$COMMENT_CHARACTER   = "#"

class LineC
    @input = []
    @hex_output = "00000000"
    @bin_output = "00000000000000000000000000000000"

    def initialize(line_in)
        if(line_in.class == "abc".class)
            @input = line_in.split("\s"||",")
        else
            @input = line_in
        end
    end

    def get_array()
        return @input
    end

    def set_output(bin_input)
        @bin_output = bin_input
        @hex_output = binary_to_hex(bin_input)
    end

    def get_output()
        if ($HEX_OUT)
            return @hex_output
        else
            return @bin_output
        end
    end

    def ascii_convert(input, bits = 16)
        output = input[1..-2].ord
        return binary_encode(output, bits)
    end

    def detect_format_and_convert(input, bits = 16)
        if (input.class == 123.class)
            integer = input
        elsif (input[0] == '\'')
            return ascii_convert(input, bits)
        elsif (input[0..1] == "0x" || input[0..1] == "0X")
            input = input[2..-1]
            input.chars.each do |a|
                if (!a.match(/\d|[a-fA-F]/))
                    abort("Invalid hex digit: #{input}")
                end
            end
            integer = input.to_i(16)
        elsif (input.length == bits)
            input.chars.each do |a|
                if (!a.match(/[01]/))
                    abort("Invalid binary digit: #{input}")
                end
            end
            integer = input.to_i(2)
        elsif (input[0] == "0")
            input.chars.each do |a|
                if (a.to_i() > 7)
                    abort("Invalid octal digit: #{input}")
                end
            end
            integer = input.to_i(8)
        else
            integer = input.to_i()
        end
        return binary_encode(integer, bits)
    end

    def binary_encode(dec, bits = 32)
        sign = dec < 0
        dec = dec.abs - (sign ? 1 : 0)
        binary = "0"
        (0..(bits-2)).each do
            binary += "0"
        end
        (0..(bits-1)).each do |n|
            if (dec != 0)
                if (dec % 2 == 1)
                    binary[(bits-1)-n] = "1"
                end
                dec = dec/2
            end
        end
        if sign
            (0..bits-1).each do |i|
                binary[i] = (binary[i] == '0') ? '1' : '0'
            end
        end
        return binary
    end
    
    def binary_to_hex(binary, bits = 32)
        integer = binary.to_i(2);
        hex = integer.to_s(16)
    
        while (hex.length < (bits/4.0).ceil) do
            hex = "0" + hex
        end
    
        hex.downcase!
        return hex
    end

    def is_directive()
        return (@input[0].chars.first == "\.") ? 1 : 0
    end

    def is_empty()
        return ((@input.nil? || @input[0].nil?) || (@input[0].chars.first == $COMMENT_CHARACTER)) ? 1 : 0
    end

    def decode_directive_mode()
        index = $DIRECTIVE_INDEX.find_index(@input[0].downcase)
        return (index == nil || $DIRECTIVE_MAP[index][1] != "S") ? -1 : $DIRECTIVE_MAP[index][2].to_i()
    end

    def check_for_labels()
        @input[0].chomp!
        if (@input[0].chars.last == ":")
            label = @input[0][0..-2]       
            return label
        else
            return 0
        end
    end

    def chop_comments()        
        @input.each_with_index do |value, index|
            if (value.chars.first == $COMMENT_CHARACTER)
                @input = @input[0, index]
            end
        end
    end

end
