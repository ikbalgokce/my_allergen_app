package com.myallergen.backend.repository;

import com.myallergen.backend.entity.Drug;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DrugRepository extends JpaRepository<Drug, Integer> {
    Optional<Drug> findFirstByIlacAdiIgnoreCase(String ilacAdi);
}
