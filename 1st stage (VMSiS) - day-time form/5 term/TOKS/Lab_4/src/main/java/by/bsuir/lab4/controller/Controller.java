package by.bsuir.lab4.controller;

import by.bsuir.lab4.creator.SerialPortCreator;
import by.bsuir.lab4.event.ClearButtonEvent;
import by.bsuir.lab4.event.InputTextAreaEvent;
import by.bsuir.lab4.event.SendButtonEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextArea;
import javafx.scene.input.MouseEvent;
import jssc.SerialPort;
import jssc.SerialPortException;

public class Controller {

    @FXML
    private TextArea input;

    @FXML
    private Button clear_input;

    @FXML
    private Button send;

    @FXML
    private TextArea output;

    @FXML
    private Button clear_output;

    @FXML
    private TextArea debug;

    @FXML
    private ComboBox<String> speed;

    private final static String[] speeds = {"110", "300", "600", "1200", "4800",
            "9600", "14400", "19200", "38400", "57600", "115200", "128000", "256000"};

    @FXML
    void initialize() {
        try {
            speed.setValue("9600");

            SerialPortCreator creator = new SerialPortCreator(output, debug);
            SerialPort port = creator.openPort();

            speed.getItems().addAll(speeds);
            send.addEventHandler(MouseEvent.MOUSE_CLICKED, (mouseEvent) -> new SendButtonEvent(speed, input, debug, port)
                    .mouseClickedEvent());
            clear_input.addEventHandler(MouseEvent.MOUSE_CLICKED, (mouseEvent) -> new ClearButtonEvent(input)
                    .mouseClickedEvent());
            clear_output.addEventHandler(MouseEvent.MOUSE_CLICKED, (mouseEvent) -> new ClearButtonEvent(output)
                    .mouseClickedEvent());
            input.textProperty().addListener((event) -> new InputTextAreaEvent(input, debug, send).inputEvent());
            debug.appendText(port.getPortName() + " successfully initialized\n");
        } catch (SerialPortException e) {
            debug.appendText("Port initialization error!\n");
            setDisable();
        }
    }

    public void setDisable() {
        send.setDisable(true);
        speed.setDisable(true);
        output.setDisable(true);
        input.setDisable(true);
        clear_output.setDisable(true);
        clear_input.setDisable(true);
    }
}

