package by.epam.web.logic;

import by.epam.web.controllers.CalculatorController;
import by.epam.web.entity.CalculableParameters;
import by.epam.web.exeptions.IllegalArgumentsException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

@Service
public class CalculatorLogic {
    private static final Logger logger = LogManager.getLogger(CalculatorController.class);
    CalculatorHash hashMap = new CalculatorHash();
    private static final int TEN = 10;

    public int calculateResult(CalculableParameters requestParameters) throws IllegalArgumentsException {
        int result = 0;

        if (hashMap.isContain(requestParameters)) {
            result = hashMap.getParameters(requestParameters);
            logger.info("get hashMap");
        } else {
            switch (requestParameters.getAction()) {
                case "plus_1":
                    result = plus_1(requestParameters.getNumber());
                    break;
                case "minus_1":
                    result = minus_1(requestParameters.getNumber());
                    break;
                case "plus_10":
                    result = plus_10(requestParameters.getNumber());
                    break;
                case "minus_10":
                    result = minus_10(requestParameters.getNumber());
                    break;
                case "empty":
                    result = requestParameters.getNumber();
                    break;
                default:
                    logger.error("400 error!");
                    throw new IllegalArgumentsException();
            }
            hashMap.addToMap(requestParameters, result);
            logger.info("add hashMap");
        }

        return result;
    }

    public int plus_1(int number) {
        return ++number;
    }

    public int minus_1(int number) {
        return --number;
    }

    public int plus_10(int number) {
        return number + TEN;
    }

    public int minus_10(int number) {
        return number - TEN;
    }
}
