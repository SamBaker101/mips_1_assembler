#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler
####################

#TODO: Reg instructions should accept 2 or 3 regs

require "./bin/line_c.rb"
require "./bin/instruction_c.rb"
require "./bin/data_c.rb"

$IN = "samples/sample1.asm"
$OUT = "output/out.txt"

$COMMENT_CHARACTER   = "#"
$HEX_OUT             = 1

module Mode
    DATA = 0
    RDATA = 1
    TEXT = 2
end

def main()
    in_file = File.new($IN, "r")
    out_file = File.new($OUT, "w")
    
    mode = Mode::TEXT

    read_q  = []
    inst_q  = []
    label_q = []
    
    total_lines = 0
    line_num = 0
    
    while (line = in_file.gets)
        total_lines += 1
        read_q.push(line)
    end
        
    puts "Total lines = " << total_lines.to_s
    
    while (line_num < total_lines) 
        line_array = read_q[line_num].split("\s"||",")
        line = LineC.new(line_array)
        line_num += 1
        
        next if (line.get_array[0].nil?)
        next if (line.get_array[0].chars.first == $COMMENT_CHARACTER) 
    
        line.get_array.each_with_index do |value, index|
            if (value.chars.first == $COMMENT_CHARACTER)
                line = LineC.new(line.get_array[0, index])
            end
        end

        if (line.is_section_label() == 1)
            mode = decode_section_label(line.get_array[0].downcase)
            next
        end

        case (mode) 
            when Mode::DATA 
                line = DataC.new(line.get_array())
            when Mode::RDATA 
                line = DataC.new(line.get_array())
            when Mode::TEXT 
                line = InstructionC.new(line.get_array())
        end
    
        line.read()

        #puts "Adding inst to out " << inst_out
        inst_q.push(line.get_output())
        out_file.puts(line.get_output())
    end
    
    puts "Finishing"
    
    in_file.close
    out_file.close
end

def decode_section_label(label)
    case (label)
        when "\.data"
            mode = Mode::DATA
        when  "\.rdata"
            mode = Mode::RDATA
        when  "\.text"
            mode = Mode::TEXT
        else
            abort("Unrecognized code section #{label}")
    end
    mode
end

main()


