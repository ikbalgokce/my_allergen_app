package com.myallergen.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UserMedicationCreateRequest(
        @NotBlank @Size(max = 150) String ilacAdi,
        @Size(max = 50) String ilacDozu,
        @Size(max = 100) String kullanimSikligi,
        @Size(max = 100) String hatirlatmaSaati
) {
}
