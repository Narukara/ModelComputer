import sys

instr = ["add", "and", "nor", "sft", "sub", "gt", "lt", "eq",
       "load", "loadi", "jal", "none", "jifn", "jif", "jr", "store"]

regs = ["$0", "$v", "$a0", "$a1", "$t0", "$t1", "$t2",
        "$t3", "$s0", "$s1", "$s2", "$s3", "$gp", "$sp", "$fp", "$ra"]


def instr_to_bin(s: str) -> str:
    if s not in instr:
        sys.exit(-1)
    s = bin(instr.index(s))[2:]
    return "0" * (4 - len(s)) + s


def reg_to_bin(s: str) -> str:
    if s not in regs:
        sys.exit(-1)
    s = bin(regs.index(s))[2:]
    return "0" * (4 - len(s)) + s


def num_to_bin(s: str, fill: int, ifj = False) -> str:
    i = int(s)
    if (ifj):
        i = i - 1
    if (i >= 0):
        s = bin(i)[2:]
        return "0" * (fill - len(s)) + s
    else:
        sys.exit(-1)


lines = open(sys.argv[1], 'r').read().splitlines()
out = open("code.exe", 'w')

k = 0
for l in lines:
    words = l.split()
    out.write("rom[%d] = 16'b" % k)
    out.write(instr_to_bin(words[0]) + "_")
    if (words[0] == "loadi"):
        out.write(reg_to_bin(words[1]))
        out.write(num_to_bin(words[2], 8))
    elif (words[0] == "load"):
        out.write(reg_to_bin(words[1]))
        out.write(num_to_bin(words[2], 4))
        out.write(reg_to_bin(words[3]))
    elif (words[0] == "store"):
        out.write(num_to_bin(words[1], 4))
        out.write(reg_to_bin(words[2]))
        out.write(reg_to_bin(words[3]))
    elif (words[0] == "jal"):
        out.write(reg_to_bin(words[1]))
        out.write(num_to_bin(words[2], 8, True))
    elif (words[0] == "jr"):
        out.write("00000000")
        out.write(reg_to_bin(words[1]))
    elif (words[0] == "jif" or words[0] == "jifn"):
        out.write(num_to_bin(words[1], 8, True))
        out.write(reg_to_bin(words[2]))
    else:
        out.write(reg_to_bin(words[1]))
        out.write(reg_to_bin(words[2]))
        out.write(reg_to_bin(words[3]))
    out.write(";\n")
    k += 1
