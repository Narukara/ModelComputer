loadi $a0 3
loadi $a1 2
jal $ra 11
add $t0 $v $0
store 2 $t0 $0
load $t1 0 $a1
eq $t2 $t0 $t1
jifn 8 $t2
sft $t0 $t0 $a1
jal $0 10
add $v $a0 $a1
jr $ra