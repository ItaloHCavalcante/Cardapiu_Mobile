package com.cardapiu.demo.exceptions;


import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class RestExceptionHandler {

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<String> HandleConstraintViolation(DataIntegrityViolationException exception){
        return ResponseEntity.status(409).body("Erro: Não é possivel deletar essa categoria." +
                " Existem produtos vinculados a ela. Remova-os primeiro!");
    }
}
