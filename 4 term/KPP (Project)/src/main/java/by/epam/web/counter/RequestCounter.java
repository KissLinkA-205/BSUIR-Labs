package by.epam.web.counter;

public class RequestCounter {
    private static int counter = 0;

    public static void increment() {
        counter++;
    }

    public static Integer getCounter() {
        return counter;
    }
}
