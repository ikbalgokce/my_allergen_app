package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "medications")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Medication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ilac_id")
    private Integer ilacId;

    @Column(name = "ilac_adi", nullable = false, length = 120)
    private String ilacAdi;

    @Column(name = "ilac_dozu", length = 60)
    private String ilacDozu;

    @Column(name = "kullanim_sikligi", length = 60)
    private String kullanimSikligi;

    @Column(name = "hatirlatma_saati", length = 30)
    private String hatirlatmaSaati;
}
