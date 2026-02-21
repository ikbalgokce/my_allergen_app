package com.myallergen.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;

public record UserProfileUpdateRequest(
        @NotBlank @Size(max = 100) String ad,
        @NotBlank @Size(max = 100) String soyad,
        @NotBlank @Email @Size(max = 100) String mail,
        @NotBlank @Size(max = 255) String sifre,
        @NotNull @PositiveOrZero Integer yas
) {
}
