package by.bsuir.lab4.service;

public class CadreService {
    private static final int CADRE_LENGTH = 15;

    public String[] formCadres(String data) {
        int currentCadre = 0;
        String[] result;
        if (isMessageLengthEqualsCadre(data)) {
            int cadreNumber = data.length() / CADRE_LENGTH + 1;
            result = new String[cadreNumber];
            result[cadreNumber - 1] = "000000000000000";
            while (currentCadre < cadreNumber - 1) {
                String cadre = data.substring(CADRE_LENGTH * currentCadre, CADRE_LENGTH * currentCadre + CADRE_LENGTH);
                result[currentCadre] = cadre;
                currentCadre++;
            }
        } else {
            int lengthToCadre = CADRE_LENGTH - data.length() % CADRE_LENGTH;
            int cadreNumber = (data.length() + lengthToCadre) / CADRE_LENGTH;
            result = new String[cadreNumber];
            while (currentCadre < cadreNumber - 1) {
                String cadre = data.substring(CADRE_LENGTH * currentCadre,
                        CADRE_LENGTH * currentCadre + CADRE_LENGTH);
                result[currentCadre] = cadre;
                currentCadre++;
            }
            char[] charCadre = new char[CADRE_LENGTH];

            for (int i = 0; i < CADRE_LENGTH - lengthToCadre; i++) {
                charCadre[i] = data.charAt(CADRE_LENGTH * (cadreNumber - 1) + i);
            }
            char extraBit = charCadre[CADRE_LENGTH - lengthToCadre - 1] == '1' ? '0' : '1';
            for (int i = CADRE_LENGTH - lengthToCadre; i < CADRE_LENGTH; i++) {
                charCadre[i] = extraBit;
            }
            result[currentCadre] = new String(charCadre);
        }

        return result;
    }

    public boolean isMessageLengthEqualsCadre(String data) {
        int size = data.length();
        return size != 0 && size % CADRE_LENGTH == 0;
    }

    public String deleteExtraBits(String data) {
        char extraBit = data.charAt(data.length() - 1) == '1' ? '1' : '0';
        StringBuilder result = new StringBuilder(data);
        for (int i = data.length() - 1; i > 0; i--) {
            if (data.charAt(i) == extraBit) {
                result.deleteCharAt(i);
            } else {
                break;
            }
        }
        return result.toString();
    }

    public boolean isCadreNotEmpty(String cadre) {
        return !cadre.equals("000000000000000");
    }
}
