package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "kullanici_ilac")
@IdClass(UserMedicationId.class)
@Getter
@Setter
public class UserMedication {

    @Id
    @Column(name = "kullanici_id")
    private Integer kullaniciId;

    @Id
    @Column(name = "ilac_id")
    private Integer ilacId;

    @Column(name = "ilac_dozu", length = 50)
    private String ilacDozu;

    @Column(name = "baslangic_tarihi")
    private LocalDate baslangicTarihi;

    @Column(name = "bitis_tarihi")
    private LocalDate bitisTarihi;

    @Column(name = "kullanim_sikligi", length = 100)
    private String kullanimSikligi;

    @Column(name = "hatirlatma_saati")
    private LocalTime hatirlatmaSaati;
}
