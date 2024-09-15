package by.bsuir.lab4.event;

import by.bsuir.lab4.initializer.SerialPortInitializer;
import by.bsuir.lab4.service.CSMA_CDService;
import by.bsuir.lab4.service.CadreService;
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
    private final CSMA_CDService csma_cdService;

    private static final String CARRYOVER = "\n";
    private static final String JAM_SIGNAL = "*";
    private static final int MAX_NUMBER_OF_ATTEMPTS = 10;

    public SendButtonEvent(ComboBox<String> speedButton, TextArea input, TextArea debug, SerialPort port) {
        this.speedButton = speedButton;
        this.input = input;
        this.port = port;
        this.debug = debug;
        this.csma_cdService = new CSMA_CDService();
    }

    public void mouseClickedEvent() {
        SerialPortInitializer initializer = new SerialPortInitializer();
        String baudRate = speedButton.getValue();
        initializer.initSerialPort(port, baudRate);

        debug.appendText("Information to send (speed: " + baudRate + ")" + CARRYOVER);
        CadreService cadreService = new CadreService();
        String[] cadres = cadreService.formCadres(input.getText());
        for (int i = 0; i < cadres.length; i++) {
            if (i != cadres.length - 1 || cadreService.isCadreNotEmpty(cadres[i])) {
                StringBuilder attemptCount = new StringBuilder();

                while (attemptCount.length() < MAX_NUMBER_OF_ATTEMPTS) {
                    while (csma_cdService.isChannelBusy()) {
                        //wait
                    }
                    writeToPort(cadres[i]);
                    if (csma_cdService.isCollision()) {
                        attemptCount.append(JAM_SIGNAL);
                        writeToPort(JAM_SIGNAL);
                        csma_cdService.collisionDelay(attemptCount.length());
                    } else {
                        break;
                    }
                }
                int finalI = i;
                debug.appendText(cadres[finalI] + ":" + attemptCount + '\n');
            } else {
                writeToPort(cadres[i]);
            }
        }
        writeToPort(CARRYOVER);
    }

    private void writeToPort(String message) {
        if (isPortAvailable()) {
            byte[] charMessage = message.getBytes(StandardCharsets.UTF_8);
            try {
                port.writeBytes(charMessage);
            } catch (SerialPortException e) {
                e.printStackTrace();
            }
        } else {
            debug.appendText("Unable to send data to port!" + CARRYOVER);
        }
    }

    private boolean isPortAvailable() {
        String[] portNames = SerialPortList.getPortNames();
        return Arrays.asList(portNames).contains(port.getPortName());
    }
}
