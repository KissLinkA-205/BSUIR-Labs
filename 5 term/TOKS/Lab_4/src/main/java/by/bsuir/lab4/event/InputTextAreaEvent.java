package by.bsuir.lab4.event;

import javafx.scene.control.Button;
import javafx.scene.control.TextArea;

public class InputTextAreaEvent {
    private final TextArea input;
    private final TextArea debug;
    private final Button send;

    public InputTextAreaEvent(TextArea input, TextArea debug, Button send) {
        this.input = input;
        this.debug = debug;
        this.send = send;
    }

    public void inputEvent() {
        String dataStr = input.getText();
        for (int i = 0; i < dataStr.length(); i++) {
            if (dataStr.charAt(i) != '0' && dataStr.charAt(i) != '1') {
                javafx.application.Platform.runLater( () ->debug.appendText("The message should contain only '0' and '1'!\n"));
                send.setDisable(true);
                return;
            }
        }
        send.setDisable(false);
    }
}
