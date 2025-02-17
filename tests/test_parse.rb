#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Parse Tests
####################

#parse_file()
def test_parse_file()
    puts "Test not implemented: test_parse_file("
end    

    #load_all_maps()
    #load_map(map_path, map, index)
def test_load_all_maps(parser)
    parser.load_all_maps()
    if ($INSTRUCTION_MAP[0][0] != "ADD")
        abort("ERROR: #{__method__.to_s}, $INSTRUCTION_MAP[0][0] = #{$INSTRUCTION_MAP[0][0]}")
    elsif ($DIRECTIVE_MAP[0][0] != ".text")
        abort("ERROR: #{__method__.to_s}, $DIRECTIVE_MAP[0][0] = #{$DIRECTIVE_MAP[0][0]}")
    elsif ($MNEMONIC_MAP[0][0] != "MOVE")
        abort("ERROR: #{__method__.to_s}, $MNEMONIC_MAP[0][0] = #{$MNEMONIC_MAP[0][0]}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end
end
    
    #fill_queues()
def test_fill_queues(parser)
    parser.fill_queues(File.new("samples/#{$FILE_NAME}.asm", "r"))
    if (parser.get_from_read_q(0).chomp != ".data")
        abort("ERROR: #{__method__.to_s}, read_q[0] = #{parser.get_from_read_q(0)}")
    else
        puts "TEST: #{__method__.to_s}: Completed Successfully"
    end

end

    #check_for_mode_update(line_for_check)
def test_check_for_mode_update(parser)
    mode_list = [[".text"], [".rdata"], [".data"], [".lit4"], [".lit8"], [".bss"], [".sdata"], [".sbss"]]
    (0..(mode_list.size() - 1)).each do |n|
        line = LineC.new(mode_list[n])
        parser.check_for_mode_update(line)
        if (parser.get_mode() != n)
            abort("ERROR: #{__method__.to_s}, expected = #{n}:#{mode_list[n]}, got #{parser.get_mode()}")
        end
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

    #update_line_class(array, mode)
def test_update_line_class(parser)
    class_list = ["InstructionC", "DataC", "DataC"]
    (0..(class_list.size() - 1)).each do |n|
        line = LineC.new($test_array_random)
        line = parser.update_line_class($test_array_random, n)
        if (line.class().to_s != class_list[n])
            abort("ERROR: #{__method__.to_s}, expected = #{n}:#{class_list[n]}, got #{line.class()}")
        end
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end
