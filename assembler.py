import sys

dic = {
    "add": "0000",
    "sub": "0100",
    "and": "0001",
    "nor": "0010",
    "sft": "0011",
    "gt": "0101",
    "lt": "0110",
    "eq": "0111",
    "loadi": "1001",
    "load": "1000",
    "store": "1111",
    "jal": "1010",
    "jr": "1110",
    "jif": "1101",
    "jifn": "1100"
}

regs = ["0", "v", "a0", "a1", "t0", "t1", "t2",
        "t3", "s0", "s1", "s2", "s3", "gp", "sp", "fp", "ra"]


def reg(s: str):
    if not s.startswith("$"):
        sys.exit(-1)
    s = bin(regs.index(s[1:]))[2:]
    return "0" * (4 - len(s)) + s


def num(s: str, j = False):
    i = int(s)
    if(j):
        i = i - 1
    if (i >= 0):
        s = bin(i)[2:]
        return "0" * (8 - len(s)) + s
    else:
        sys.exit(-1)

def num4(s: str):
    i = int(s)
    if (i >= 0):
        s = bin(i)[2:]
        return "0" * (4 - len(s)) + s
    else:
        sys.exit(-1)

f = open(sys.argv[1], 'r')
s = f.read()
l = s.splitlines()
fw = open("exe", 'w')

k = 0
for i in l:
    word = i.split()
    if word[0] not in dic:
        sys.exit(-1)
    fw.write("rom[%d] = 16'b" % k)
    fw.write(dic[word[0]] + "_")
    if (word[0] == "loadi"):
        fw.write(reg(word[1]) + "_")
        fw.write(num(word[2]))
    elif (word[0] == "load"):
        fw.write(reg(word[1]))
        fw.write(num4(word[2]))
        fw.write(reg(word[3]))
    elif (word[0] == "store"):
        fw.write(num4(word[1]))
        fw.write(reg(word[2]))
        fw.write(reg(word[3]))
    elif (word[0] == "jal"):
        fw.write(reg(word[1]) + "_")
        fw.write(num(word[2], True))
    elif (word[0] == "jr"):
        fw.write("00000000_")
        fw.write(reg(word[1]))
    elif (word[0] == "jif" or word[0] == "jifn"):
        fw.write(num(word[1], True) + "_")
        fw.write(reg(word[2]))
    else:
        fw.write(reg(word[1]) + "_")
        fw.write(reg(word[2]) + "_")
        fw.write(reg(word[3]))
    fw.write(";\n")
    k += 1
