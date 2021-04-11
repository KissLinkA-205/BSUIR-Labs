package by.epam.web.logic;

import by.epam.web.entity.CalculableParameters;
import org.springframework.stereotype.Component;

import java.util.HashMap;

@Component
public class CalculatorHash {
    private final HashMap<CalculableParameters, Integer> hashMap = new HashMap<>();

    public boolean isContain(CalculableParameters key) {
        return hashMap.containsKey(key);
    }

    public void addToMap(CalculableParameters key, Integer result) {
        hashMap.put(key, result);
    }

    public Integer getParameters(CalculableParameters key) {
        return hashMap.get(key);
    }
}
