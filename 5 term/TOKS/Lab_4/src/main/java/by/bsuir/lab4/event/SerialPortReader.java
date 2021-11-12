package by.bsuir.lab4.event;

import by.bsuir.lab4.service.CadreService;
import javafx.scene.control.TextArea;
import jssc.SerialPort;
import jssc.SerialPortEvent;
import jssc.SerialPortEventListener;
import jssc.SerialPortException;

import java.nio.charset.StandardCharsets;

public class SerialPortReader implements SerialPortEventListener {
    private final SerialPort port;
    private final TextArea output;

    private static final char END_MSG = '\n';
    private static final char JAM_SIGNAL = '*';
    private static StringBuilder result;

    public SerialPortReader(SerialPort port, TextArea output) {
        this.port = port;
        this.output = output;
        result = new StringBuilder();
    }

    @Override
    public void serialEvent(SerialPortEvent serialPortEvent) {
        if (serialPortEvent.isRXCHAR() && serialPortEvent.getEventValue() > 0) {
            try {
                CadreService cadreService = new CadreService();
                byte[] dataByteFormat = port.readBytes(serialPortEvent.getEventValue());
                String data = new String(dataByteFormat, StandardCharsets.UTF_8);

                for (int i = 0; i < data.length(); i++) {
                    if (data.charAt(i) == END_MSG) {
                        String cadre = result.substring(result.length() - 15, result.length());
                        result.delete(result.length() - 15, result.length());
                        if (cadreService.isCadreNotEmpty(cadre)) {
                            result.append(cadreService.deleteExtraBits(cadre));
                        }
                        output.appendText(result + "\n");
                        result.delete(0, result.length());
                        break;
                    }
                    if (data.charAt(i) == JAM_SIGNAL) {
                        result.delete(result.length() - 15, result.length());
                        continue;
                    }
                    result.append(data.charAt(i));
                }
            } catch (SerialPortException e) {
                e.printStackTrace();
            }
        }
    }
}
