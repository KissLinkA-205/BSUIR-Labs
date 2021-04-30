package by.epam.web.controllers;

import by.epam.web.counter.Synchronization;
import by.epam.web.entity.CalculableParameters;
import by.epam.web.exeptions.IllegalArgumentsException;
import by.epam.web.logic.CalculatorLogic;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.LinkedList;
import java.util.List;

@Controller
@ControllerAdvice
public class CalculatorController {
    private static final Logger logger = LogManager.getLogger(CalculatorController.class);
    @Autowired
    private CalculatorLogic calculatorLogic;

    @GetMapping("/calculator")
    public String calculateParams(@RequestParam(name = "number", required = false, defaultValue = "0") int number,
                                  @RequestParam(name = "action", required = false, defaultValue = "empty") String action,
                                  Model model) throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setAction(action);
        requestParameters.setNumber(number);
        Integer result = calculatorLogic.calculateResult(requestParameters);

        Synchronization.semaphore.release();

        model.addAttribute("message", "Результат: " + result);
        model.addAttribute("number", result);
        logger.info("Successfully getMapping");
        return "home";
    }

    @PostMapping("/calculator")
    public ResponseEntity<?> calculateBulkParams(@Valid @RequestBody List<CalculableParameters> bodyList) {

        List<Integer> resultList = new LinkedList<>();
        bodyList.forEach((currentElement) -> {
            try {
                resultList.add(calculatorLogic.calculateResult(currentElement));
            } catch (IllegalArgumentsException e) {
                logger.error("Error in postMapping");
            }
        });

        logger.info("Successfully postMapping");
        int sumResult = calculatorLogic.calculateSumOfResult(resultList);
        int maxResult = calculatorLogic.findMaxOfResult(resultList);
        int minResult = calculatorLogic.findMinOfResult(resultList);

        return new ResponseEntity<>(resultList + "\nSum: " + sumResult + "\nMax result: " +
                maxResult + "\nMin result: " + minResult, HttpStatus.OK);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public String handlerException() {
        logger.info("handlerException");
        return ("/error/400.html");
    }
}