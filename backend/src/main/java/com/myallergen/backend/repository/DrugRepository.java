package com.myallergen.backend.repository;

import com.myallergen.backend.entity.Drug;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface DrugRepository extends JpaRepository<Drug, Integer> {
    Optional<Drug> findFirstByIlacAdiIgnoreCase(String ilacAdi);

    @Query(
            value = "SELECT CASE WHEN EXISTS ("
                    + "SELECT 1 FROM ilaclar i "
                    + "WHERE LOWER(LTRIM(RTRIM(i.ilac_adi))) = LOWER(LTRIM(RTRIM(:name))) "
                    + "OR LOWER(ISNULL(i.etkin_madde, '')) LIKE '%' + LOWER(LTRIM(RTRIM(:name))) + '%'"
                    + ") THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END",
            nativeQuery = true
    )
    boolean existsByIlacAdiOrEtkinMaddeContains(@Param("name") String name);
}
