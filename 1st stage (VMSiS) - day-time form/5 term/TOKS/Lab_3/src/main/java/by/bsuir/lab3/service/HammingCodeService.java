package by.bsuir.lab3.service;

import java.util.ArrayList;
import java.util.List;

public class HammingCodeService {
    private static final int NUMBER_OF_CONTROL_BITS = 5;

    public String generateRandomError(String cadre) {
        char[] result = cadre.toCharArray();
        int randomNumber = (int) (Math.random() * 9);

        if (randomNumber % 5 == 0) {
            int errorIndex1 = (int) (Math.random() * cadre.length() - 1);
            result[errorIndex1] = result[errorIndex1] == '1' ? '0' : '1';
            int errorIndex2 = errorIndex1;
            while (errorIndex2 == errorIndex1) {
                errorIndex2 = (int) (Math.random() * cadre.length() - 1);
            }
            result[errorIndex2] = result[errorIndex2] == '1' ? '0' : '1';
        } else {
            if (randomNumber % 2 == 0) {
                int errorIndex = (int) (Math.random() * cadre.length() - 1);
                result[errorIndex] = result[errorIndex] == '1' ? '0' : '1';
            }
        }
        return String.valueOf(result);
    }

    public String insertControlBits(String cadre) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < NUMBER_OF_CONTROL_BITS; i++) {
            StringBuilder stringBuilder = new StringBuilder(cadre);
            stringBuilder.insert((int) Math.pow(2, i) - 1, "0");
            cadre = stringBuilder.toString();
        }
        result.append(cadre).append('0');

        return calculateControlBits(result.toString());
    }

    public String calculateControlBits(String cadre) {
        StringBuilder result = new StringBuilder(cadre);
        for (int i = 0; i < NUMBER_OF_CONTROL_BITS; i++) {
            int start = (int) Math.pow(2, i) - 1;
            int checkLength = (int) Math.pow(2, i);
            int oneCount = 0;
            for (int j = start; j < result.length() - 1; j += 2 * checkLength) {
                for (int length = 0; length < checkLength && j + length < result.length() - 1; length++) {
                    if (start == j + length) {
                        continue;
                    }
                    if (result.charAt(j + length) == '1') {
                        oneCount++;
                    }
                }
            }
            if (oneCount % 2 == 0) {
                result.replace(start, start + 1, "0");
            } else {
                result.replace(start, start + 1, "1");
            }
        }
        int p = calculateXorBit(result.toString());
        result.setCharAt(result.length() - 1, (char) (p + 48));
        return result.toString();
    }

    public int calculateXorBit(String cadre) {
        StringBuilder result = new StringBuilder(cadre);
        int p = result.charAt(0) - 48;
        for (int i = 1; i < result.length(); i++) {
            p ^= result.charAt(i) - 48;
        }
        return p;
    }

    public String deleteControlBits(String cadre) {
        StringBuilder result = new StringBuilder(cadre);
        for (int i = NUMBER_OF_CONTROL_BITS - 1; i >= 0; i--) {
            int index = (int) (Math.pow(2, i) - 1);
            result.deleteCharAt(index);
        }
        result.deleteCharAt(result.length() - 1);
        return result.toString();
    }

    public int calculateC(String cadre) {
        String calculated = calculateControlBits(cadre);
        List<Integer> mistakeIndexList = new ArrayList<>();
        for (int i = 0; i < cadre.length() - 1; i++) {
            if (cadre.charAt(i) != calculated.charAt(i)) {
                mistakeIndexList.add(i + 1);
            }
        }
        return mistakeIndexList.stream().mapToInt(Integer::intValue).sum();
    }
}
