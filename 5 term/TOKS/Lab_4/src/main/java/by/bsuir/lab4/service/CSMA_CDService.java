package by.bsuir.lab4.service;

public class CSMA_CDService {

    public boolean isChannelBusy() {
        int randomNumber = (int) (Math.random() * 9);
        return randomNumber % 5 == 0;
    }

    public boolean isCollision() {
        int randomNumber = (int) (Math.random() * 9);
        return randomNumber % 2 == 0;
    }

    public void collisionDelay(int attemptNumber) {
        try {
            Thread.sleep(Math.min(attemptNumber, 10) * 100L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
