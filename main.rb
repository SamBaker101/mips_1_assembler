#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler
####################

#TODO: Reg instructions should accept 2 or 3 regs

require "./src/line_c.rb"
require "./src/instruction_c.rb"
require "./src/data_c.rb"

$IN = "samples/sample1.asm"
$OUT = "output/out.txt"

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
        line = LineC.new(read_q[line_num])
        line_num += 1
        
        next if (line.is_empty() == 1)
        line.chop_comments()

        if (line.is_directive() == 1)
            mode = line.decode_directive_mode(mode)
            next
        end

        #TODO: Check the entire file for labels befor start parsing instructions
        label_check = line.check_for_labels()
        if (label_check != 0)
            #TODO: This should be indexed by the label not the value, will make lookup a pain
            label_q[line_num] = label_check
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
    
    label_q.each_with_index do |l, n|
        if (l == nil) 
            next 
        end
        puts "Label: #{l}:#{n}"
    end
    
    in_file.close
    out_file.close
end

main()


