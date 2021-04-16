package by.epam.web;

import by.epam.web.entity.CalculableParameters;
import by.epam.web.exeptions.IllegalArgumentsException;
import by.epam.web.logic.CalculatorHash;
import org.junit.jupiter.api.Test;
import by.epam.web.logic.CalculatorLogic;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class CalculatorHashTest {
    CalculatorHash hashMap = new CalculatorHash();
    private final CalculatorLogic calculatorLogic = new CalculatorLogic();

    @Test
    void testCalculateHashIsContainFalse() {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(9);
        requestParameters.setAction("minus_10");

        boolean result = hashMap.isContain(requestParameters);
        assertFalse(result);
    }

    @Test
    void testCalculateHashIsContainTrue() {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(9);
        requestParameters.setAction("minus_10");
        int result = -1;
        hashMap.addToMap(requestParameters, result);
        assertEquals(result, hashMap.getParameters(requestParameters));
    }

    @Test
    void testCalculateHash() throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(10);
        requestParameters.setAction("minus_10");

        calculatorLogic.calculateResult(requestParameters);

        int expected = 0;
        assertEquals(expected, calculatorLogic.calculateResult(requestParameters));
    }
}
