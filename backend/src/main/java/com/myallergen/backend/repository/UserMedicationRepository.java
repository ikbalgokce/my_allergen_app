package com.myallergen.backend.repository;

import com.myallergen.backend.entity.UserMedication;
import com.myallergen.backend.entity.UserMedicationId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserMedicationRepository extends JpaRepository<UserMedication, UserMedicationId> {

    @Query(
            value = "SELECT "
                    + "ui.ilac_id AS ilacId, "
                    + "COALESCE(i.ilac_adi, 'Bilinmeyen Ilac') AS ilacAdi, "
                    + "ui.ilac_dozu AS ilacDozu, "
                    + "ui.kullanim_sikligi AS kullanimSikligi, "
                    + "CONVERT(VARCHAR(5), ui.hatirlatma_saati, 108) AS hatirlatmaSaati, "
                    + "CONVERT(VARCHAR(10), ui.baslangic_tarihi, 23) AS baslangicTarihi, "
                    + "CONVERT(VARCHAR(10), ui.bitis_tarihi, 23) AS bitisTarihi, "
                    + "i.sure_siniri AS sureSiniri "
                    + "FROM kullanici_ilac ui "
                    + "LEFT JOIN ilaclar i ON i.id = ui.ilac_id "
                    + "WHERE ui.kullanici_id = :userId "
                    + "ORDER BY ui.hatirlatma_saati",
            nativeQuery = true
    )
    List<TodayMedicationProjection> findTodayMedicationRows(@Param("userId") Integer userId);

    @Query(
            value = "SELECT "
                    + "i.ilac_adi AS ilacAdi, "
                    + "i.etkin_madde AS etkinMadde "
                    + "FROM kullanici_ilac ui "
                    + "INNER JOIN ilaclar i ON i.id = ui.ilac_id "
                    + "WHERE ui.kullanici_id = :userId",
            nativeQuery = true
    )
    List<UserMedicationRiskProjection> findRiskRows(@Param("userId") Integer userId);
}
