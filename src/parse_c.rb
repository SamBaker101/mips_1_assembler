#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Parser Class
####################

$MEM_SIZE               = 0x006000
$MEM_INST_OFFSET        = 0x000000
$MEM_DATA_OFFSET        = 0x002000

module Mode
    TEXT    = 0
    RDATA   = 1
    DATA    = 2
    LIT4    = 3
    LIT8    = 4
    BSS     = 5
    SDATA   = 6
    SBSS    = 7
end

class ParseC 
    @in_file       

    @mode

    @read_q  
    @label_q
    
    @inst_q
    @data_q 
    @rdata_q

    @total_lines
    @line_num 
    @instr_num

    @mem

    def initialize()
        load_all_maps()
    
        @in_file        = File.new("samples/#{$FILE_NAME}.asm", "r")

        @mode       = Mode::TEXT
        @read_q     = []
        @label_q    = {}

        @inst_q     = []
        @data_q     = []
        @rdata_q    = []
            
        @total_lines    = 0
        @line_num       = 0
        @instr_num      = 0

        @line

        @mem = MemC.new($MEM_SIZE, $MEM_INST_OFFSET, $MEM_DATA_OFFSET, self)
    end

    def get_from_read_q(index)
        return @read_q[index]
    end

    def get_mode()
        return @mode
    end

    def load_all_maps()
        load_map($INST_MAP_FILE, $INSTRUCTION_MAP, $INSTRUCTION_INDEX)
        load_map($DIR_MAP_FILE, $DIRECTIVE_MAP, $DIRECTIVE_INDEX)
        load_map($MNE_MAP_FILE, $MNEMONIC_MAP, $MNEMONIC_INDEX)
    end

    def load_map(map_path, map, index)
        map_file = File.new(map_path, "r")    
        map_file.gets #Skip header
        while (line = map_file.gets) 
        
            line = line.split(",")
            line.each do |item|
                item.chomp!
                item.strip!
            end
            map.push(line)
            index.push(line[0])
        end
    end

    def fill_queues(in_file)
        temp_q = []

        while (line = in_file.gets)

            #TODO: Do this more gracefully so you don't have to repeat it
            
            lines = line.split(";")
            lines.each_with_index do |value, index|
                if (value.chars.first == $COMMENT_CHARACTER)
                    lines = lines[0, index]
                end
            end

            lines.each do |l|
                temp_q.push(l)
            end
        end

        temp_q.each do |l|
            l = check_mnemonics(l)
           
            l.each do |m|
                m.strip!
                next if m.nil?
                next if m.length == 0

                @read_q.push(m)
                @total_lines += 1    
            end
        end

        print_read_q()
        fill_label_q()

    end

    def fill_label_q()
        address = 0
        data = 0
        @read_q.each do |line|
            puts line
            @line = LineC.new(line)
            next if @line.get_array[0].nil?

            if (@line.get_array[0].strip == '.data')
                address = $MEM_DATA_OFFSET
                data    = 1
            elsif (@line.get_array[0].strip == '.text')
                address = $MEM_INST_OFFSET
                data    = 0
            end
            
            next if (@line.is_directive() == 1) && 
                ![".half", ".word", ".float", ".double"].include?(@line.get_array[0])

            if data == 1
                case (@line.get_array[1])
                when ".half"
                    while (address % 2 != 0)
                       address += 1
                    end
                when ".word"
                    while (address % 4 != 0)
                        address += 1
                     end
                when ".float"
                    while (address % 4 != 0)
                        address += 1
                     end
                when ".double"
                    while (address % 8 != 0)
                        address += 1
                     end
                end
            end

            label_check = @line.check_for_labels()
            if (label_check != 0)
                @label_q[label_check.strip] = "0x" + (address).to_s(16)
                @line = LineC.new(@line.get_array()[1..-1])
            end
            
            if (@line.is_empty == 0)
                case (@line.get_array[0])
                    when ".space"
                        address += @line.get_array[1].to_i
                    when ".byte"
                        @line.get_array[1..-1].each do 
                            address += 1
                        end
                    when ".half"
                        @line.get_array[1..-1].each do 
                            address += 2
                        end
                    when ".word"
                        @line.get_array[1..-1].each do 
                            address += 4
                        end
                    when ".float"
                        @line.get_array[1..-1].each do 
                            address += 4
                        end
                    when ".double"
                        @line.get_array[1..-1].each do 
                            address += 8
                        end
                    else
                        address += 4
                    end
            end
            @instr_num += 1
        end
    end

    def check_for_mode_update(line_for_check)
        if (line_for_check.is_directive() == 1)
            new_mode = line_for_check.decode_directive_mode()
            if (new_mode != -1)
                @mode = new_mode 
                return 1
            end
        end
        return 0
    end

    def check_mnemonics(line)
        puts "CHECKING MNEMONIC FOR #{line}"
        
        line_q = [line]
        line.strip!
        line = line.split(" "||",")

        line.each_with_index do |value, index|
            if (value.chars.first == $COMMENT_CHARACTER)
                line = line[0, index]
            end
        end

        if (!line[0].nil?)
            index = $MNEMONIC_INDEX.find_index(line[0].upcase)
            if (index != nil)
                line_q = []
                $MNEMONIC_MAP[index][1..-1].each do |mnem|
                    line_q = line_q + [mnem.dup]
                end
                line_q.each_with_index do |n, i|
                    line_q[i].sub! '#{label}', line[-1]
                    if (line.length == 4)
                        line_q[i].sub! '#{rd}', line[1]
                        line_q[i].sub! '#{Imm}', line[3]
                    
                        if (["BGE", "BGEZ", "BGEU", "BGT", "BGTU", "BLE", "BLEU", "BLT", "BLTU"].include?(line[0].upcase) && (line[2][0] != '$'))
                            line_q[i].sub! 'slt', 'slti'
                            line_q[i].sub! 'sltu', 'sltiu'
                            line_q[i].sub! '#{rs}', line[1]
                            line_q[i].sub! '#{rt}', line[2]
                        else
                            line_q[i].sub! '#{rs}', line[1]
                            line_q[i].sub! '#{rt}', line[2]                        
                        
                        end
                    elsif (line.length == 3)
                        line_q[i].sub! '#{rd}', line[1]
                        line_q[i].sub! '#{rs}', line[2]
                        line_q[i].sub! '#{rt}', line[2]

                    end
                end
               
            else
                temp_line = LineC.new(line)
                address = line[-1].split("("||")")
                value   = address[0]

                case(line[0].upcase)  
                    when "MUL"
                        if (line[-1][0] == '$')
                            return line
                        else
                            return ["addi $at $zero #{line[-1]}", "mul #{line[1]} #{line[2]} $at"]
                        end
                    when "LA"
                        is_a_label = 0
                        if (!value.match?(/[0-9a-fA-F]+/) && !value.match?(/[0-9]+/))
                                                 
                            value   = temp_line.detect_format_and_convert(value, 32).to_i(2)

                            hi      = binary_value[16..31].to_s.to_i(2)
                            low     = binary_value[0..15].to_s.to_i(2)
                        
                        elsif (address.length > 1)
                            #Can't find documentation on this addressing mode but MARS interprets it as below
                            return ["ori $at $r0 #{address[0]}]", "add #{line[1]} #{address[1]} $at"]
                        else
                            is_a_label = 1
                        end

                        if (is_a_label == 1)
                            return ["addi #{line[1]} $r0 #{value}" ]
                        elsif (address.length == 1)
                            if (hi == 0)
                                return ["addi #{line[1]} $r0 #{low}" ]
                            else
                                return [ "lui $at #{hi}",
                                     "addi #{line[1]} $at #{low}" ]
                            end
                        else
                            if (value < 32000 && value > -32000)
                                return ["addiu #{line[1]} #{address[1]} #{value}"]
                            else
                                return    [ "lui $at, #{hi}",
                                            "addi #{line[1]} $at, #{low}",
                                            "add #{line[1]} #{line[1]} #{address[1]}"]
                            end
                        end
                    when "LI"   
                  
                        value   = value.to_i
                        binary_value =  value.to_s(2)
                        hi      = binary_value[16..31].to_s.to_i(2)
                        low     = binary_value[0..15].to_s.to_i(2)

                        if (value < 32000 && value > -32000)
                            return ["addiu #{line[1]} $r0 #{value}"]
                        elsif (hi == 0)
                            return ["ori #{line[1]} $r0 #{value}"]
                        elsif (low == 0)
                            return ["lui #{line[1]} #{value}"]
                        else
                            return  [ "lui #{line[1]} #{low.to_i(2)}",
                                      "ori #{line[1]} #{line[1]} #{hi.to_i(2)}" ] 
                        end
                end
            end
        end
        
        return line_q
    end

    def update_line_class(array, mode)
        case (mode) 
            when Mode::DATA 
                return DataC.new(array, @mem)
            when Mode::RDATA 
                return DataC.new(array, @mem)
            when Mode::TEXT 
                return InstructionC.new(array, @mem)
        end
    end

    def parse_input()
        puts "Total lines = " << @total_lines.to_s
        @line_num = 0
        while (@line_num <= @total_lines) 
            @line = LineC.new(@read_q[@line_num])
            @line_num += 1
            
            next if (@line.is_empty() == 1)

            if (@line.check_for_labels != 0)
                next if @line.get_array().length == 1
                @line = LineC.new(@line.get_array()[1..-1])
            end

            next if (check_for_mode_update(@line) == 1)

            @line = update_line_class(@line.get_array(), @mode)
            @line.read(@label_q, @line_num)
        end
    end

    def check_label_q(value)
        if (value.class == 1.class)
            return value
        else
            address = @label_q[value.strip]
            #puts "Label: #{value}:#{@label_q[value.strip]}::#{value.class}"
            if (address.nil?)
                return value
            else
                return address
            end                
        end
    end

    def close_files()
        @in_file.close
        #out files are closed by mem
        @mem.close_files()
    end

    def parse_file()
        fill_queues(@in_file)
        print_labels()
        parse_input()        
        @mem.print_out_files()        
        close_files()
    end

    def print_labels()
        @label_q.each do |l, i|
            if (l == nil) 
                next 
            end
            puts "Label: #{l}:#{i}::#{l.class}"
        end
    end

    def print_read_q()
        puts "READ_Q CONTENTS:"
        @read_q.each_with_index do |m, i|
            puts "#{i} : #{m}"
        end
    end

end
