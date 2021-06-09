int fibbo(int i) {
    if (i < 3) {
        return 1;
    } else {
        return fibbo(i - 1) + fibbo(i - 2);
    }
}

int main(){
    fibbo(10);
    while(1);
}