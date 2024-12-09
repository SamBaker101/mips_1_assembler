#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Parser Class
####################

$MEM_SIZE               = 0x006000
$MEM_INST_OFFSET        = 0
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
            #puts "#{line[0]}:#{line[1]}:#{line[2]}:#{line[3]}:#{line[4]}"
            map.push(line)
            index.push(line[0])
        end
    end

    def fill_queues(in_file)
        while (line = in_file.gets)
            @total_lines += 1
            lines = line.split(";")
            lines.each do |l|
                @read_q.push(l)
            end
        end

        fill_label_q()
        temp_q = @read_q
        @read_q = []

        temp_q.each do |l|
            l = check_mnemonics(l)
            l.each do |m|
                @read_q.push(m)
            end
        end
    end

    def fill_label_q()
        address = 0
        data = 0
        @read_q.each do |line|
            @line = LineC.new(line)
            
            next if (@line.is_empty() == 1)

            if (@line.get_array[0].strip == '.data')
                address = $MEM_DATA_OFFSET
                data    = 1
            elsif (@line.get_array[0].strip == '.text')
                address = $MEM_INST_OFFSET
                data    = 0
            end
            
            next if (@line.is_directive() == 1)

            label_check = @line.check_for_labels()
            if (label_check != 0)
                @label_q[label_check.strip] = "0x" + (address).to_s(16)
            end 

            if (data == 0)
                address += 4
            else 
                case (@line.get_array[1])
                    when ".byte"
                        @line.get_array[2..-1].each do 
                            address += 1
                        end
                    when ".half"
                        @line.get_array[2..-1].each do 
                            address += 2
                        end
                    when ".word"
                        @line.get_array[2..-1].each do 
                            address += 4
                        end
                    when ".float"
                        @line.get_array[2..-1].each do 
                            address += 4
                        end
                    when ".double"
                        @line.get_array[2..-1].each do 
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
        line_q = [line]
        line.strip!
        line = line.split(" "||",")
        if (!line[0].nil?)
            index = $MNEMONIC_INDEX.find_index(line[0].upcase)
            if (index != nil)
                line_q = $MNEMONIC_MAP[index][1..-1]
                line_q.each_with_index do |n, i|
                    #TODO: There are alot more cases to be dealt with here
                    if (line.length == 4)
                        line_q[i].sub! '#{rd}', line[1]
                        line_q[i].sub! '#{rs}', line[2]
                        line_q[i].sub! '#{rt}', line[3]
                        line_q[i].sub! '#{Imm}', line[3]
                    else (line.length == 3)
                        line_q[i].sub! '#{rd}', line[1]
                        line_q[i].sub! '#{rs}', line[2]
                        line_q[i].sub! '#{rt}', line[2]
                    end
                    
                    puts "#{i} :: #{line_q[i]}"
                end
            else
                #TODO: These could be simplified alot if I move the format conversion functions out of LineC and generalize them
                temp_line = LineC.new(line)
                address = line[-1].split("("||")")
                value   = check_label_q(address[0])


                case(line[0].upcase)    
                    when "LA"
                        if (value.class != 1.class)                        
                            value   = temp_line.detect_format_and_convert(value, 32).to_i(2)
                        end
                        binary_value =  value.to_s(2)
                        hi      = binary_value[16..31].to_s.to_i(2)
                        low     = binary_value[0..15].to_s.to_i(2)

                        puts "#{address[0]} : #{value} : #{binary_value} : #{hi} : #{low}" 
                        if (address.length == 1)
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
                        if (value.class != 1.class)                        
                            value   = temp_line.detect_format_and_convert(value, 32).to_i
                        end
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
            
            next if (@label_q[@line_num] != nil)
            next if (@line.is_empty() == 1)
            next if (@line.check_for_labels != 0)
    
            @line.chop_comments()
            next if (check_for_mode_update(@line) == 1)

            @line = update_line_class(@line.get_array(), @mode)
            @line.read(@label_q, @line_num)
        end
    end

    def print_labels()
        @label_q.each do |l, i|
            if (l == nil) 
                next 
            end
            puts "Label: #{l}:#{i}::#{l.class}"
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
        @mem.close_files()
    end

    def parse_file()
        fill_queues(@in_file)
        print_labels()
        parse_input()        
        @mem.print_out_files()        
        close_files()
    end
end
