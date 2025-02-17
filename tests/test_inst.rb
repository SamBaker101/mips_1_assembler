#!/usr/bin/env/ruby

# Sam Baker 09/2024
# MIPS_1 Assembler - Instruction Tests
####################

#read()
def test_read()
    puts "Test not implemented: #{__method__.to_s}"
end

#is_reg(operand)
def test_is_reg(inst)
    if (inst.is_reg("addu") != 0)
        abort(abort("ERROR: #{__method__.to_s}, input = addu, out = #{1}"))
    end
    if (inst.is_reg("$at") == 0)
        abort(abort("ERROR: #{__method__.to_s}, input = $at, out= #{0}"))
    end
    puts "TEST: #{__method__.to_s}: Completed Successfully"
end

#decode_operation()
def test_decode_operation(inst)
    puts "Test not implemented: #{__method__.to_s}"
end

#decode_reg(string)
def test_decode_reg(inst)
    puts "Test not implemented: #{__method__.to_s}"
end

#encode()
def test_encode(inst)
    puts "Test not implemented: #{__method__.to_s}"
end
