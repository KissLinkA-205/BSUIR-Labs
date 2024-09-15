package by.bsuir.lab3.creator;

import by.bsuir.lab3.event.SerialPortReader;
import javafx.scene.control.TextArea;
import jssc.SerialPort;
import jssc.SerialPortException;

public class SerialPortCreator {
    private static final String COM1 = "COM1";
    private static final String COM2 = "COM2";

    private TextArea output;
    private TextArea debug;

    public SerialPortCreator(TextArea output, TextArea debug) {
        this.output = output;
        this.debug = debug;
    }

    public SerialPort openPort() throws SerialPortException {
        try {
            debug.appendText("Trying to open " + COM1 + "...\n");
            return createSerialPort(COM1);
        } catch (SerialPortException e) {
            debug.appendText("Trying to open " + COM2 + "...\n");
            return createSerialPort(COM2);
        }
    }

    private SerialPort createSerialPort(String portName) throws SerialPortException {
        SerialPort port = new SerialPort(portName);
        port.openPort();
        port.addEventListener(new SerialPortReader(port, output, debug), SerialPort.MASK_RXCHAR);
        return port;
    }
}
