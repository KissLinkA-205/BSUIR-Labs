package by.epam.web.controllers;

import by.epam.web.entity.CalculableParameters;
import by.epam.web.exeptions.IllegalArgumentsException;
import by.epam.web.logic.CalculatorLogic;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


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

        model.addAttribute("message", "Результат: " + result);
        model.addAttribute("number", result);
        logger.info("Successfully");
        return "home";
    }
}
