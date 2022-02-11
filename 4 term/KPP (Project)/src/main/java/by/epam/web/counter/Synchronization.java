package by.epam.web.counter;

import org.springframework.stereotype.Component;

import java.util.concurrent.Semaphore;

@Component
public class Synchronization {
    public final static Semaphore semaphore = new Semaphore(1, true);
}
