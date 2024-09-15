package by.bsuir.lab3.event;

import javafx.scene.control.TextArea;

public class ClearButtonEvent {
    private TextArea textArea;

    public ClearButtonEvent(TextArea textArea) {
        this.textArea = textArea;
    }

    public void mouseClickedEvent() {
        textArea.clear();
    }
}
