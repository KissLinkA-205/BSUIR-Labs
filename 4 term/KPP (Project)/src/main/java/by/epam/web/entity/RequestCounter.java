package by.epam.web.entity;

public class RequestCounter extends Thread {
    private static Integer counter = 0;

    public synchronized void incrementCounter() {
        if (this.isRunnable()) {
            counter++;
        } else {
            this.start();
            counter++;
        }
    }

    public synchronized Integer getCounter() {
        return counter;
    }

    @Override
    public synchronized void start() {
        super.start();
    }

    public synchronized boolean isRunnable() {
        return super.isAlive() && !super.isInterrupted();
    }
}
