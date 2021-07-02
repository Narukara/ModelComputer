loadi $sp 255           // bootloader : set stack pointer
loadi $a0 10            // main() start from here
jal $ra 5               // call fibbo()
jal $0 4                // while(1);
loadi $t0 3             // fibbo() start from here
lt $t1 $a0 $t0
jifn 10 $t1
loadi $v 1
jr $ra                  // return 1
sub $sp $sp $t0
store 3 $ra $sp
store 2 $s0 $sp
store 1 $s1 $sp
add $s0 $a0 $0
loadi $t2 1
sub $a0 $s0 $t2
jal $ra 5               // call fibbo(n-1)
add $s1 $v $0
loadi $t0 2
sub $a0 $s0 $t0
jal $ra 5               // call fibbo(n-2)
add $v $v $s1
load $ra 3 $sp
load $s0 2 $sp
load $s1 1 $sp
loadi $t0 3
add $sp $sp $t0
jr $ra                  // return the sum