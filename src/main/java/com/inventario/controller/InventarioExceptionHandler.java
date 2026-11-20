package com.inventario.controller;

import jakarta.persistence.EntityNotFoundException;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice(assignableTypes = {InventarioController.class, SalidaController.class})
public class InventarioExceptionHandler {

    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String datosInvalidos(BindException exception) {
        return exception.getFieldErrors().stream()
                .map(error -> error.isBindingFailure()
                        ? "El valor de " + error.getField() + " no es válido."
                        : error.getDefaultMessage())
                .distinct().collect(Collectors.joining(" "));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String operacionInvalida(IllegalArgumentException exception) {
        return exception.getMessage();
    }

    @ExceptionHandler(EntityNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String productoInexistente(EntityNotFoundException exception) {
        return exception.getMessage();
    }
}
