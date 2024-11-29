#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Parser Class
####################

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
    @inst_out_file 
    @data_out_file 

    @mode

    @read_q  
    @label_q
    
    @inst_q
    @data_q 
    @rdata_q

    @total_lines
    @line_num 
    @instr_num
    @working_lines

    def initialize()
        load_all_maps()
    
        @in_file        = File.new("samples/#{$FILE_NAME}.asm", "r")
        @inst_out_file  = File.new("output/#{$FILE_NAME}_inst.txt", "w")
        @data_out_file  = File.new("output/#{$FILE_NAME}_data.txt", "w")
        @out_file       = File.new("output/#{$FILE_NAME}.txt", "w")

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
        @working_lines = []
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

    def update_line_class(array, mode)
        case (mode) 
            when Mode::DATA 
                return DataC.new(array)
            when Mode::RDATA 
                return DataC.new(array)
            when Mode::TEXT 
                return InstructionC.new(array)
        end
    end

    def parse_input()
        puts "Total lines = " << @total_lines.to_s
        @line_num = 0
        while (@line_num < @total_lines) 
            @line = LineC.new(@read_q[@line_num])
            @line_num += 1
            
            next if (@label_q[@line_num] != nil)
            next if (@line.is_empty() == 1)
            next if (@line.check_for_labels != 0)
    
            @line.chop_comments()
            next if (check_for_mode_update(@line) == 1)

            @line = update_line_class(@line.get_array(), @mode)
            @working_lines = @line.read(@label_q, @line_num)

            @working_lines.each do |i|
                pointer = get_pointer()
                (i.size()/2).times do |j|
                    $MEM_ARRAY[pointer] = i[(j*2) .. (j*2 + 1)]
                    pointer += 1
                end
                set_pointer(pointer)
            end
        end
    end

    def get_pointer()
        case (@mode) 
            when Mode::DATA 
                pointer = $MEM_DATA_POINTER
            when Mode::RDATA 
                pointer = $MEM_DATA_POINTER #FIXME: This should have a seperate address range
            when Mode::TEXT 
                pointer = $MEM_INST_POINTER
        end
        return pointer
    end

    def set_pointer(pointer)
        case (@mode) 
            when Mode::DATA 
                 $MEM_DATA_POINTER = pointer
            when Mode::RDATA 
                $MEM_DATA_POINTER = pointer#FIXME: This should have a seperate address range
            when Mode::TEXT 
                $MEM_INST_POINTER = pointer
        end
    end

    #TODO: Checks are pretty ugly here, should be cleaned up or abstracted
    def print_to_file(line_length = 4)
        ($MEM_INST_OFFSET .. $MEM_INST_POINTER - 1).each do |i|
            if ((i - $MEM_INST_OFFSET) != 0 && ((i - $MEM_INST_OFFSET) % line_length) == 0)
                @inst_out_file.puts("")
            end
            @inst_out_file.print($MEM_ARRAY[i])
        end

        ($MEM_DATA_OFFSET .. $MEM_DATA_POINTER - 1 ).each do |i|
            if ((i - $MEM_DATA_OFFSET) != 0 && ((i - $MEM_DATA_OFFSET) % line_length) == 0)
                @data_out_file.puts("")
            end
            @data_out_file.print($MEM_ARRAY[i])
        end

        $MEM_ARRAY.each_with_index do |item, i|
            if (i != 0 && i % line_length == 0)
                @out_file.puts("")
            end
            @out_file.print(item)
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
        @inst_out_file.close
        @data_out_file.close
        @out_file.close
    end

    def parse_file()
        fill_queues(@in_file)
        print_labels()
        parse_input()        
        print_to_file()        
        close_files()
    end
end
