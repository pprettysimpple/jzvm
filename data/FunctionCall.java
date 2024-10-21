class FunctionCall {

    static void nothing() {
        // nothing
    }

    static int ret42() {
        return 42;
    }

    static void acceptArg(int x) {
        // nothing
    }

    static int doubleArg(int x) {
        return x * 2;
    }

    static int divide(int x, int y) {
        return x / y;
    }

    public static void main(String[] args) {
        nothing();

        int a = ret42();

        acceptArg(42);

        int b = doubleArg(1);

        int c = divide(a, b);
    }
}
