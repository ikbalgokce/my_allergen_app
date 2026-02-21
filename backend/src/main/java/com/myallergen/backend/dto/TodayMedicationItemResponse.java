package com.myallergen.backend.dto;

public record TodayMedicationItemResponse(
        Integer ilacId,
        String ilacAdi,
        String ilacDozu,
        String kullanimSikligi,
        String hatirlatmaSaati,
        String baslangicTarihi,
        String bitisTarihi,
        String sureSiniri
) {
}
