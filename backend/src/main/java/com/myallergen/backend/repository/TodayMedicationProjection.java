package com.myallergen.backend.repository;

public interface TodayMedicationProjection {
    Integer getIlacId();

    String getIlacAdi();

    String getIlacDozu();

    String getKullanimSikligi();

    String getHatirlatmaSaati();

    String getBaslangicTarihi();

    String getBitisTarihi();

    String getSureSiniri();
}
