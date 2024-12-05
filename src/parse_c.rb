#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Parser Class
####################

$MEM_SIZE               = 2048
$MEM_INST_OFFSET        = 0
$MEM_DATA_OFFSET        = 512

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
                l = check_mnemonics(l)
                l.each do |m|
                    @read_q.push(m)
                end
            end

            @line = LineC.new(line)
            next if (@line.is_empty() == 1)
            next if (@line.is_directive() == 1)
    
            label_check = @line.check_for_labels()
            if (label_check != 0)
                @label_q.store(label_check , ((@instr_num * 4) + $INST_OFFSET.to_i(16)).to_s(16))
                next
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
                puts "INDEX FOUND #{index}"
            else
                case(line[0].upcase)    
                    when "LA"
                        puts "LA"
                    when "LI"    
                        puts "LI"
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
        @label_q.each_with_index do |l, i|
            if (l == nil) 
                next 
            end
            puts "Label: #{i}:#{l}"
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
