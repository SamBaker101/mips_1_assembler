# Sam Baker 09/2024
# MIPS_1 Assembler
####################

IN = "input/in.txt"
OUT = "output/out.txt"

in_file = File.new(IN, "r")
out_file = File.new(OUT, "w")

while (line = in_file.gets)
    out_file.puts(line)
end

in_file.close
out_file.close
