package by.bsuir.lab1.event;

import by.bsuir.lab1.initializer.SerialPortInitializer;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextArea;
import jssc.SerialPort;
import jssc.SerialPortException;
import jssc.SerialPortList;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class SendButtonEvent {
    private ComboBox<String> speedButton;
    private TextArea input;
    private TextArea debug;
    private SerialPort port;

    private static final String CARRYOVER = "\n";

    public SendButtonEvent(ComboBox<String> speedButton, TextArea input, TextArea debug, SerialPort port) {
        this.speedButton = speedButton;
        this.input = input;
        this.port = port;
        this.debug = debug;
    }

    public void mouseClickedEvent() {
        try {
            if (isPortAvailable()) {
                SerialPortInitializer initializer = new SerialPortInitializer();
                String baudRate = speedButton.getValue();
                initializer.initSerialPort(port, baudRate);
                byte[] message = (input.getText() + CARRYOVER).getBytes(StandardCharsets.UTF_8);
                port.writeBytes(message);
                debug.appendText("Information sent (speed: " + baudRate + ")" + CARRYOVER);
            } else {
                debug.appendText("Unable to send data to port!" + CARRYOVER);
            }
        } catch (SerialPortException e) {
            e.printStackTrace();
        }
    }

    private boolean isPortAvailable() {
        String[] portNames = SerialPortList.getPortNames();
        return Arrays.asList(portNames).contains(port.getPortName());
    }
}
