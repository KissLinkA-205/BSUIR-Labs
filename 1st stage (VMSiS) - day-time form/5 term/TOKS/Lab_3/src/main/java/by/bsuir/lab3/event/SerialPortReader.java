package by.bsuir.lab3.event;

import by.bsuir.lab3.service.CadreService;
import by.bsuir.lab3.service.HammingCodeService;
import javafx.scene.control.TextArea;
import jssc.SerialPort;
import jssc.SerialPortEvent;
import jssc.SerialPortEventListener;
import jssc.SerialPortException;

import java.nio.charset.StandardCharsets;

public class SerialPortReader implements SerialPortEventListener {
    private final SerialPort port;
    private final TextArea output;
    private final TextArea debug;

    private static final int NUMBER_OF_CONTROL_BITS = 5;

    public SerialPortReader(SerialPort port, TextArea output, TextArea debug) {
        this.port = port;
        this.output = output;
        this.debug = debug;
    }

    @Override
    public void serialEvent(SerialPortEvent serialPortEvent) {
        if (serialPortEvent.isRXCHAR() && serialPortEvent.getEventValue() > 0) {
            try {
                byte[] dataByteFormat = port.readBytes(serialPortEvent.getEventValue());
                String outputData = new String(dataByteFormat, StandardCharsets.UTF_8);
                javafx.application.Platform.runLater( () ->debug.appendText("Acquired information:\n"));

                CadreService cadreService = new CadreService();
                HammingCodeService hammingCodeService = new HammingCodeService();
                String[] cadres = cadreService.splitDataToCadres(outputData);

                for (int i = 0; i < cadres.length; i++) {
                    if (i == cadres.length - 1 &&
                            cadreService.isCadreNotEmpty(hammingCodeService.deleteControlBits(cadres[i]))) {
                        cadres[i] = checkCorrectnessOfCadre(cadres[i]);
                        cadres[i] = hammingCodeService.deleteControlBits(cadres[i]);
                        cadres[i] = cadreService.deleteExtraBits(cadres[i]);
                        int finalI = i;
                        javafx.application.Platform.runLater( () ->output.appendText(cadres[finalI]));
                    }
                    if (i != cadres.length - 1) {
                        cadres[i] = checkCorrectnessOfCadre(cadres[i]);
                        cadres[i] = hammingCodeService.deleteControlBits(cadres[i]);
                        int finalI1 = i;
                        javafx.application.Platform.runLater( () ->output.appendText(cadres[finalI1]));
                    }
                }
                javafx.application.Platform.runLater( () ->output.appendText("\n"));
            } catch (SerialPortException e) {
                e.printStackTrace();
            }
        }
    }

    private String checkCorrectnessOfCadre(String data) {
        HammingCodeService hammingCodeService = new HammingCodeService();
        int c = hammingCodeService.calculateC(data);
        int parityBit = hammingCodeService.calculateXorBit(data);
        if (parityBit == 0 && c == 0) {
            printDebugInformation(1, data, c);
        } else if (parityBit == 0) {
            printDebugInformation(3, data, c);
        } else {
            if (parityBit == 1 && c == 0) {
                c = 21;
            }
            printDebugInformation(2, data, c);
            char[] result = data.toCharArray();
            result[c - 1] = result[c - 1] == '1' ? '0' : '1';
            data = String.valueOf(result);
        }
        return data;
    }

    private void printDebugInformation(int errorType, String data, Integer c) {
        StringBuilder result = new StringBuilder(data);

        switch (errorType) {
            case 1:
                javafx.application.Platform.runLater(() -> debug.appendText("NO ERRORS "));
                break;
            case 2:
                javafx.application.Platform.runLater(() -> debug.appendText("SINGLE ERROR "));
                break;
            case 3:
                javafx.application.Platform.runLater(() -> debug.appendText("DOUBLE ERROR "));
                break;
        }

        for (int i = 0; i < NUMBER_OF_CONTROL_BITS; i++) {
            result.insert((int) Math.pow(2, i) - 1 + i * 2, "[");
            result.insert((int) Math.pow(2, i) + 1 + i * 2, "]");
        }
        result.insert(result.length() - 1, "[");
        result.insert(result.length(), "]");
        if (errorType == 2) {
            result = insertErrorHighlight(result.toString(), c - 1);
        }

        String binaryС = String.format("%5s", Integer.toString(c, 2))
                .replace(' ', '0');
        StringBuilder finalResult = result;
        javafx.application.Platform.runLater(() -> debug.appendText(finalResult + " : " + binaryС + "\n"));
    }

    private StringBuilder insertErrorHighlight(String data, int cIndex) {
        int additionalIndex = calculateAdditionalIndex(cIndex);
        StringBuilder result = new StringBuilder(data);
        result.insert(cIndex + additionalIndex, "'");
        result.insert(cIndex + additionalIndex + 2, "'");
        return result;
    }

    private int calculateAdditionalIndex(int cIndex) {
        int additionalIndex = 1;
        if (cIndex > 0) {
            additionalIndex = 3;
        }
        if (cIndex > 1) {
            additionalIndex = 4;
        }
        if (cIndex > 2) {
            additionalIndex = 5;
        }
        if (cIndex > 3) {
            additionalIndex = 6;
        }
        if (cIndex > 6) {
            additionalIndex = 7;
        }
        if (cIndex > 7) {
            additionalIndex = 8;
        }
        if (cIndex > 14) {
            additionalIndex = 9;
        }
        if (cIndex > 15) {
            additionalIndex = 10;
        }
        if (cIndex > 19) {
            additionalIndex = 11;
        }
        return additionalIndex;
    }
}

