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
        if (pointer % bytes != 0)
            pointer += (bytes - pointer % bytes)
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

    #TODO: Checks are pretty ugly here, should be cleaned up or abstracted
    def print_to_file(line_length = 4)
        (@mem_inst_offset .. @mem_inst_pointer - 1).each do |i|
            if ((i - @mem_inst_offset) != 0 && ((i - @mem_inst_offset) % line_length) == 0)
                @inst_out_file.puts("")
            end
            @inst_out_file.print(@mem_array[i])
        end

        (@mem_data_offset .. @mem_data_pointer - 1 ).each do |i|
            if ((i - @mem_data_offset) != 0 && ((i - @mem_data_offset) % line_length) == 0)
                @data_out_file.puts("")
            end
            @data_out_file.print(@mem_array[i])
        end

        @mem_array.each_with_index do |item, i|
            if (i != 0 && i % line_length == 0)
                @out_file.puts("")
            end
            @out_file.print(item)
        end
    end

    def close_files()
        @inst_out_file.close
        @data_out_file.close
        @out_file.close
    end

end
