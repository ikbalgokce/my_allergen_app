package com.myallergen.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record MedicationRequest(
        @NotBlank @Size(max = 120) String ilacAdi,
        @Size(max = 60) String ilacDozu,
        @Size(max = 60) String kullanimSikligi,
        @Size(max = 30) String hatirlatmaSaati
) {
}
