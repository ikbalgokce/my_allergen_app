package com.myallergen.backend.dto;

public record DrugInformationResponse(
        Integer id,
        String ilacAdi,
        String kisaBilgi,
        String uyariProaktifNot,
        String sureSiniri,
        String ilacBesinEtkilesimi,
        String ilacYasamTarziEtkilesimi,
        String uygulamaSekli,
        String ilacIlacCakismasi,
        String kullanimSikligi
) {
}
