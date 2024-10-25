#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Line Class Definition
####################

class LineC
    module Mode
        DATA = 0
        RDATA = 1
        TEXT = 2
    end
    

    @input = []
    @hex_output = "00000000"
    @bin_output = "00000000000000000000000000000000"

    def initialize(array)
        @input = array
    end

    def get_array()
        return @input  #TODO: Move comment, nil and type checks into this class to avoid need to return input
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

    def detect_format_and_convert(input, bits = 16)
        if (input.class == 123.class)
            binary = self.binary_encode(input, 16)  
            return binary
        elsif (input[0..1] == "0x" || input[0..1] == "0X")
            input = input[2..-1]
            input.chars.each do |a|
                if (!a.match(/\d|[a-fA-F]/))
                    abort("Invalid octal digit: #{input}")
                end
            end
            integer = input.to_i(16)
            binary  = integer.to_s(2)
            while (binary.length < bits) do
                binary = "0" + binary
            end
            return binary
        elsif (input.length == bits)
            input.chars.each do |a|
                if (!a.match(/[01]/))
                    abort("Invalid binary digit: #{input}")
                end
            end
            return input
        elsif (input[0] == "0")
            input.chars.each do |a|
                if (a.to_i() > 7)
                    abort("Invalid octal digit: #{input}")
                end
            end
            integer = input.to_i(8)
            binary  = integer.to_s(2)
            while (binary.length < bits) do
                binary = "0" + binary
            end
            return binary
        else
            return input
        end
    end

    def binary_encode(dec, bits = 32)
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
        binary
    end
    
    def binary_to_hex(binary, bits = 32)
        integer = binary.to_i(2);
        hex = integer.to_s(16)
    
        while (hex.length < (bits/4.0).ceil) do
            hex = "0" + hex
        end
    
        hex.downcase!
        #puts "#{binary} \t: #{integer} \t: #{hex}"
        hex
    end

    def is_directive()
        if (@input[0].chars.first == "\.")
            return 1
        else
            return 0
        end
    end

    def decode_directive()
        case (@input[0].downcase)
            when "\.data"
                return Mode::DATA
            when  "\.rdata"
                return Mode::RDATA
            when  "\.text"
                return Mode::TEXT
            else
                abort("Unrecognized code section #{label}")
        end
    end
end
