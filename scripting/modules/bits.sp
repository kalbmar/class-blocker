bool Bit_Check(int flags, int bit) {
    return (flags & (1 << bit)) > 0;
}

int Bit_Remove(int flags, int bit) {
    return flags & ~(1 << bit);
}

int Bit_Invert(int flags, int bit) {
    return flags ^ (1 << bit);
}
