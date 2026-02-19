package com.myallergen.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record AddAllergenRequest(
        @NotBlank @Size(max = 100) String name
) {
}
