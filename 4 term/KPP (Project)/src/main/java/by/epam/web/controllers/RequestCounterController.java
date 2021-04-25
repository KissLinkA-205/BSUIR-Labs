package by.epam.web.controllers;

import by.epam.web.entity.RequestCounter;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RequestCounterController {
    @GetMapping(value = "/counter")
    public String getCounter() {
        RequestCounter counter = new RequestCounter();
        return counter.getCounter() + " запросов было выполнено";
    }
}
