package com.myallergen.backend.dto;

public record UserProfileResponse(
        Integer userId,
        String ad,
        String soyad,
        String mail,
        String sifre,
        Integer yas
) {
}
