package by.bsuir.lab4.initializer;

import jssc.SerialPort;
import jssc.SerialPortException;

public class SerialPortInitializer {
    public void initSerialPort(SerialPort port, String baudRate) {
        try {
            port.setParams(Integer.parseInt(baudRate), SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
            port.setFlowControlMode(SerialPort.FLOWCONTROL_RTSCTS_IN | SerialPort.FLOWCONTROL_RTSCTS_OUT);
        } catch (SerialPortException e) {
            e.printStackTrace();
        }
    }
}
