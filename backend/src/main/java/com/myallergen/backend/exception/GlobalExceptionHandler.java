package com.myallergen.backend.exception;

import com.myallergen.backend.dto.LoginResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AuthException.class)
    public ResponseEntity<LoginResponse> handleAuthException(AuthException ex) {
        LoginResponse response = new LoginResponse(false, ex.getCode(), ex.getMessage(), null, null, null);
        return ResponseEntity.status(ex.getStatus()).body(response);
    }
}
