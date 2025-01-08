#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Mem Class
####################

class MemC 
    @mem_size            
    @mem_inst_offset     
    @mem_inst_pointer    

    @mem_data_offset     
    @mem_data_pointer    

    @parser
    @mem_array          

    @inst_out_file
    @data_out_file
    @out_file     

    def initialize(mem_size, inst_offset, data_offset, parser)
        @mem_size               = mem_size
        @mem_inst_offset        = inst_offset
        @mem_inst_pointer       = @mem_inst_offset
        
        @mem_data_offset        = data_offset
        @mem_data_pointer       = @mem_data_offset
        
        @parser                 = parser
        @mem_array              = Array.new(@mem_size, "00")        
    
        @inst_out_file  = File.new("output/#{$FILE_NAME}_inst.txt", "w")
        @data_out_file  = File.new("output/#{$FILE_NAME}_data.txt", "w")
        @out_file       = File.new("output/#{$FILE_NAME}.txt", "w")
    end

    def get_byte(address)
        return @mem_array[address]
    end

    def set_byte(address, value)
        @mem_array[address] = value
    end

    def write_into_mem(line)
        pointer = get_pointer()
        (line.size()/2).times do |j|
            @mem_array[pointer] = line[(j*2) .. (j*2 + 1)]
            pointer += 1
        end
        set_pointer(pointer)
    end

    def align(bytes)
        pointer = get_pointer()
        while (pointer % bytes != 0) do
            #puts "#{pointer}::#{bytes}:#{pointer % bytes}"
            @mem_array[pointer] = "00"
            pointer += 1
        end
        set_pointer(pointer) 
    end

    def get_pointer()
        case (@parser.get_mode()) 
            when Mode::DATA 
                pointer = @mem_data_pointer
            when Mode::RDATA 
                pointer = @mem_data_pointer #FIXME: This should have a seperate address range
            when Mode::TEXT 
                pointer = @mem_inst_pointer
        end
        return pointer
    end

    def set_pointer(pointer)
        case (@parser.get_mode()) 
            when Mode::DATA 
                 @mem_data_pointer = pointer
            when Mode::RDATA 
                @mem_data_pointer = pointer#FIXME: This should have a seperate address range
            when Mode::TEXT 
                @mem_inst_pointer = pointer
        end
    end

    def print_out_files(line_length = 4)
        print_to_file(line_length, @inst_out_file, @mem_inst_offset, @mem_inst_pointer)
        print_to_file(line_length, @data_out_file, @mem_data_offset, @mem_data_pointer)
        print_to_file(line_length, @out_file, 0, @mem_size)
    end

    def print_to_file(line_length, file, start, finish)
        line = Array.new(line_length, "00")
        (start .. finish).each do |i|
            if ((i - start) != 0 && (i % line_length == 0))
                (0..line_length - 1).each do |j|
                    file.print(line[(line_length - 1) - j])
                end
                file.puts("")
            end
            line[i % line_length] = (@mem_array[i])
        end
    end

    def close_files()
        @inst_out_file.close
        @data_out_file.close
        @out_file.close
    end

end
