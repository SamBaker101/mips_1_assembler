# Sam Baker 09/2024
# MIPS_1 Assembler
####################

IN = "input/in.txt"
OUT = "output/out.txt"

in_file = File.new(IN, "r")

while (line = in_file.gets)
    puts line
end

in_file.close

