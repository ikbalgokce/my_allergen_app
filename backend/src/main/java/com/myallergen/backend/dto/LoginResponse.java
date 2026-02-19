package com.myallergen.backend.dto;

public record LoginResponse(
        boolean success,
        String code,
        String message,
        Integer userId,
        String ad,
        String soyad
) {
}
