package com.myallergen.backend.dto;

public record MedicationItemResponse(
        Integer ilacId,
        String ilacAdi,
        String ilacDozu,
        String kullanimSikligi,
        String hatirlatmaSaati
) {
}
