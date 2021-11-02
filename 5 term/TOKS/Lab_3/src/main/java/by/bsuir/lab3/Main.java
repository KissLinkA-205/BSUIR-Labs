package by.bsuir.lab3;

import by.bsuir.lab3.initializer.SceneInitializer;
import javafx.stage.Stage;

import java.io.IOException;

public class Main extends javafx.application.Application {
    @Override
    public void start(Stage stage) throws IOException {
        SceneInitializer initializer = new SceneInitializer();
        initializer.initScene(stage);
    }

    public static void main(String[] args) {
        launch(args);
        System.exit(0);
    }

}