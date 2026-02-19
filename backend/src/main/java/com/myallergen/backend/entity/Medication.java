package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "medications")
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

    public Medication() {
    }

    public Integer getIlacId() {
        return ilacId;
    }

    public void setIlacId(Integer ilacId) {
        this.ilacId = ilacId;
    }

    public String getIlacAdi() {
        return ilacAdi;
    }

    public void setIlacAdi(String ilacAdi) {
        this.ilacAdi = ilacAdi;
    }

    public String getIlacDozu() {
        return ilacDozu;
    }

    public void setIlacDozu(String ilacDozu) {
        this.ilacDozu = ilacDozu;
    }

    public String getKullanimSikligi() {
        return kullanimSikligi;
    }

    public void setKullanimSikligi(String kullanimSikligi) {
        this.kullanimSikligi = kullanimSikligi;
    }

    public String getHatirlatmaSaati() {
        return hatirlatmaSaati;
    }

    public void setHatirlatmaSaati(String hatirlatmaSaati) {
        this.hatirlatmaSaati = hatirlatmaSaati;
    }
}
