package by.bsuir.lab2.service;

import javafx.scene.control.TextArea;

import java.util.Objects;

public class BitStaffingService {
    private static final String STAFFING_FLAG = "0000111";
    private static final String DESTAFFING_FLAG = "00001110";
    private static final String CARRYOVER = "\n";

    private static String bufferForOut = "1111111";
    private static String bufferFromInput = "11111111";

    public String bitStaffing(String data, TextArea debug) {
        StringBuilder result = new StringBuilder();
        String dataWithBuffer = bufferForOut.substring(bufferForOut.length() - 7) + data;
        bufferForOut = dataWithBuffer;
        String[] splitData = (dataWithBuffer + CARRYOVER).split(STAFFING_FLAG);
        int sizeOfCroppedData = 7;

        if (splitData[0].length() >= 7) {
            splitData[0] = splitData[0].substring(7);
        } else {
            sizeOfCroppedData = splitData[0].length();
            splitData[0] = "";
        }

        for (int i = 0; i < splitData.length; i++) {
            debug.appendText(splitData[i]);
            result.append(splitData[i]);
            if (i < splitData.length - 1) {
                if (!Objects.equals(splitData[i + 1], CARRYOVER)) {
                    debug.appendText(STAFFING_FLAG.substring(7 - sizeOfCroppedData) + "[0]");
                    result.append(STAFFING_FLAG.substring(7 - sizeOfCroppedData)).append("0");
                } else {
                    debug.appendText(STAFFING_FLAG.substring(7 - sizeOfCroppedData));
                    result.append(STAFFING_FLAG.substring(7 - sizeOfCroppedData));
                }
                sizeOfCroppedData = 7;
            }
        }
        return result.toString().split(CARRYOVER)[0];
    }

    public String bitDestaffing(String data) {
        StringBuilder result = new StringBuilder();
        String dataWithBuffer = bufferFromInput.substring(bufferFromInput.length() - 8) + data;
        bufferFromInput = dataWithBuffer;
        String[] splitData = (dataWithBuffer + CARRYOVER).split(DESTAFFING_FLAG);
        int sizeOfCroppedData = 8;

        if (splitData[0].length() >= 8) {
            splitData[0] = splitData[0].substring(8);
        } else {
            sizeOfCroppedData = splitData[0].length();
            splitData[0] = "";
        }

        for (int i = 0; i < splitData.length; i++) {
            result.append(splitData[i]);
            if (i < splitData.length - 1) {
                result.append(STAFFING_FLAG.substring(8 - sizeOfCroppedData));
                sizeOfCroppedData = 8;
            }
        }
        return result.toString().split(CARRYOVER)[0];
    }
}
