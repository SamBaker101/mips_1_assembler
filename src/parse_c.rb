#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Parser Class
####################

class ParseC 
    @in_file       
    @inst_out_file 
    @data_out_file 

    @mode

    @read_q  
    @inst_q  
    @label_q 

    def initialize()
        load_maps()
    
        in_file = File.new($IN, "r")
        inst_out_file = File.new($INST_OUT, "w")
        data_out_file = File.new($DATA_OUT, "w")
    
        @mode = Mode::TEXT
    end

    def load_maps()
        map_file = File.new($MAP_FILE, "r")    
        while (line = map_file.gets) 
            line = line.split(",")
            line.each do |item|
                item.chomp!
                item.strip!
            end
            #puts "#{line[0]}:#{line[1]}:#{line[2]}:#{line[3]}:#{line[4]}"
            $INSTRUCTION_MAP.push(line)
            $INSTRUCTION_INDEX.push(line[0])
        end
    end

    def parse_file()
        @read_q  = []
        @inst_q  = []
        @label_q = {}
        
        total_lines = 0
        line_num = 0
        instr_num =0
    
        while (line = in_file.gets)
            total_lines += 1
            read_q.push(line)
    
            line = LineC.new(line)
            next if (line.is_empty() == 1)
            next if (line.is_directive() == 1)
    
            label_check = line.check_for_labels()
            if (label_check != 0)
                label_q.store(label_check , ((instr_num * 4) + $INST_OFFSET.to_i(16)).to_s(16))
                next
            end 
            instr_num += 1
        end
            
        puts "Total lines = " << total_lines.to_s
        line_num = 0
        while (line_num < total_lines) 
            line = LineC.new(read_q[line_num])
            line_num += 1
            
            next if (label_q[line_num] != nil)
            next if (line.is_empty() == 1)
            next if (line.check_for_labels != 0)
    
            line.chop_comments()
    
            if (line.is_directive() == 1)
                mode = line.decode_directive_mode(mode)
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
        
            line.read(label_q, line_num)
    
            #puts "Adding inst to out " << inst_out
            inst_q.push(line.get_output())
            inst_out_file.puts(line.get_output())
        end
        
        puts "Finishing"
        
        label_q.each do |l|
            if (l == nil) 
                next 
            end
            puts "Label: #{l}"
        end
        
        in_file.close
        inst_out_file.close
    end
end
