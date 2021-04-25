package by.epam.web.exeptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.BAD_REQUEST,reason = "invalid data")
public class IllegalArgumentsException extends Exception{
    public IllegalArgumentsException() {
    }
    public IllegalArgumentsException(String message) {
        super(message);
    }

    public IllegalArgumentsException(String message, Throwable cause) {
        super(message, cause);
    }

    public IllegalArgumentsException(Throwable cause) {
        super(cause);
    }
}
