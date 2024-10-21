class Loop {

    static int inc(int i) {
        return i + 1;
    }

    public static void main(String[] args) {
        for (int i = 0; i < 500 * 1000; i = inc(i)) {
        }
    }
}
