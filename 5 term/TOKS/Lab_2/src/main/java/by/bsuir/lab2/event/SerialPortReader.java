package by.bsuir.lab2.event;

import by.bsuir.lab2.service.BitStaffingService;
import javafx.scene.control.TextArea;
import jssc.SerialPort;
import jssc.SerialPortEvent;
import jssc.SerialPortEventListener;
import jssc.SerialPortException;

import java.nio.charset.StandardCharsets;

public class SerialPortReader implements SerialPortEventListener {
    private SerialPort port;
    private TextArea output;

    public SerialPortReader(SerialPort port, TextArea output) {
        this.port = port;
        this.output = output;
    }

    @Override
    public void serialEvent(SerialPortEvent serialPortEvent) {
        if (serialPortEvent.isRXCHAR() && serialPortEvent.getEventValue() > 0) {
            try {
                byte[] dataByteFormat = port.readBytes(serialPortEvent.getEventValue());
                String outputData = new String(dataByteFormat, StandardCharsets.UTF_8);
                BitStaffingService service = new BitStaffingService();
                outputData = outputData.substring(0, outputData.length() - 1);
                String textToOutput = service.bitDestaffing(outputData);
                output.appendText(textToOutput + "\n");
            } catch (SerialPortException e) {
                e.printStackTrace();
            }
        }
    }
}
