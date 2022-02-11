package by.epam.web;

import by.epam.web.entity.CalculableParameters;
import by.epam.web.exeptions.IllegalArgumentsException;
import by.epam.web.logic.CalculatorLogic;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;


class CalculatorLogicTest {

    private final CalculatorLogic calculatorLogic = new CalculatorLogic();

    @Test
    void testCalculateResultPlus_10() throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(9);
        requestParameters.setAction("plus_10");

        int expected = 19;
        assertEquals(expected, calculatorLogic.calculateResult(requestParameters));
    }

    @Test
    void testCalculateResultMinus_10() throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(9);
        requestParameters.setAction("minus_10");

        int expected = -1;
        assertEquals(expected, calculatorLogic.calculateResult(requestParameters));
    }

    @Test
    void testCalculateResultPlus_1() throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(9);
        requestParameters.setAction("plus_1");

        int expected = 10;
        assertEquals(expected, calculatorLogic.calculateResult(requestParameters));
    }

    @Test
    void testCalculateResultMinus_1() throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setNumber(9);
        requestParameters.setAction("minus_1");

        int expected = 8;
        assertEquals(expected, calculatorLogic.calculateResult(requestParameters));
    }

    @Test
    void testCalculateResultEmpty() throws IllegalArgumentsException {
        CalculableParameters requestParameters = new CalculableParameters();

        int expected = 0;
        assertEquals(expected, calculatorLogic.calculateResult(requestParameters));
    }

    @Test
    void testCalculateResultError() {
        boolean resultException = false;
        try {
            CalculableParameters requestParameters = new CalculableParameters();
            requestParameters.setAction("qwerty");

            calculatorLogic.calculateResult(requestParameters);
        } catch (IllegalArgumentsException e) {
            resultException = true;
        }
        assertTrue(resultException);
    }
}