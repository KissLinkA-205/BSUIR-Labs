package by.bsuir.lab1.initializer;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;
import java.net.URL;

public class SceneInitializer {
    private static final String RESOURCE = "/main.fxml";
    private static final String TITLE = "COM-port transmitter";

    public void initScene(Stage stage) throws IOException {
        URL url = getClass().getResource(RESOURCE);
        Parent root = FXMLLoader.load(url);
        stage.setScene(new Scene(root));
        stage.setResizable(false);
        stage.setTitle(TITLE);
        stage.show();
    }
}