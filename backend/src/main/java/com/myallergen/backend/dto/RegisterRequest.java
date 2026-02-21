package com.myallergen.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @NotBlank @Size(max = 50) String ad,
        @NotBlank @Size(max = 50) String soyad,
        @NotBlank @Email @Size(max = 100) String mail,
        @NotBlank @Size(max = 255) String sifre,
        @NotBlank @Size(max = 50) String kullaniciAd,
        @NotNull @Min(0) @Max(130) Integer yas
) {
}
