package by.epam.web;

import by.epam.web.entity.CalculableParameters;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class CalculableParametersTest {
    @Test
    void testCalculableParametersEquals() {
        CalculableParameters requestParameters1 = new CalculableParameters();
        CalculableParameters requestParameters2 = new CalculableParameters();

        boolean result = requestParameters1.equals(requestParameters2);
        assertTrue(result);
    }

    @Test
    void estCalculableParametersToString() {
        CalculableParameters requestParameters = new CalculableParameters();
        requestParameters.setAction("plus_10");
        requestParameters.setNumber(9);

        String result = "\n" + requestParameters.getClass().getName() + "{" +
                "number=" + 9 +
                ", action='" + "plus_10" + "}";

        assertEquals(requestParameters.toString(), result);
    }
}