package by.bsuir.lab3.event;

import by.bsuir.lab3.initializer.SerialPortInitializer;
import by.bsuir.lab3.service.CadreService;
import by.bsuir.lab3.service.HammingCodeService;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextArea;
import jssc.SerialPort;
import jssc.SerialPortException;
import jssc.SerialPortList;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class SendButtonEvent {
    private final ComboBox<String> speedButton;
    private final TextArea input;
    private final TextArea debug;
    private final SerialPort port;

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
                if (!input.getText().isEmpty()) {
                    SerialPortInitializer initializer = new SerialPortInitializer();
                    String baudRate = speedButton.getValue();
                    initializer.initSerialPort(port, baudRate);
                    debug.appendText("Information sent (speed: " + baudRate + ")" + CARRYOVER);

                    CadreService cadreService = new CadreService();
                    HammingCodeService hammingCodeService = new HammingCodeService();
                    String[] cadres = cadreService.formCadres(input.getText());
                    StringBuilder toSend = new StringBuilder();
                    for (int i = 0; i < cadres.length; i++) {
                        cadres[i] = hammingCodeService.insertControlBits(cadres[i]);
                        if (i != cadres.length - 1 || cadreService.isCadreNotEmpty(
                                hammingCodeService.deleteControlBits(cadres[i]))) {
                            cadres[i] = hammingCodeService.generateRandomError(cadres[i]);
                        }
                        toSend.append(cadres[i]);
                    }

                    byte[] message = (toSend.toString()).getBytes(StandardCharsets.UTF_8);
                    port.writeBytes(message);
                }
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
