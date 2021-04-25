package by.epam.web.controllers;

import by.epam.web.entity.CalculableParameters;
import by.epam.web.entity.RequestCounter;
import by.epam.web.exeptions.IllegalArgumentsException;
import by.epam.web.logic.CalculatorLogic;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.LinkedList;
import java.util.List;

@Controller
public class CalculatorController {
    private static final Logger logger = LogManager.getLogger(CalculatorController.class);
    @Autowired
    private CalculatorLogic calculatorLogic;

    @GetMapping("/calculator")
    public String greeting(@RequestParam(name = "number", required = false, defaultValue = "0") int number,
                           @RequestParam(name = "action", required = false, defaultValue = "empty") String action,
                           Model model) throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setAction(action);
        requestParameters.setNumber(number);
        Integer result = calculatorLogic.calculateResult(requestParameters);

        RequestCounter counter = new RequestCounter();
        counter.incrementCounter();

        model.addAttribute("message", "Результат: " + result);
        model.addAttribute("number", result);
        logger.info("Successfully getMapping");
        return "home";
    }

    @PostMapping("/calculator")
    public ResponseEntity<?> bulkParams(@RequestBody List<CalculableParameters> bodyList) {
        List<Integer> copyList = new LinkedList<>();

        bodyList.forEach((tmp) -> {
            try {
                copyList.add(calculatorLogic.calculateResult(tmp));
            } catch (IllegalArgumentsException e) {
                logger.error("Error in postMapping");
            }
        });
        logger.info("Successfully postMapping");

        int sumResult = copyList
                .stream()
                .mapToInt(Integer::intValue)
                .sum();

        int maxResult = copyList
                .stream()
                .mapToInt(Integer::intValue)
                .max().getAsInt();

        int minResult = copyList
                .stream()
                .mapToInt(Integer::intValue)
                .min().getAsInt();

        return new ResponseEntity<>(copyList + "\nСумма: " + sumResult + "\nМаксимальный результат: " +
                maxResult + "\nМинимальный результат: " + minResult, HttpStatus.OK);
    }
}