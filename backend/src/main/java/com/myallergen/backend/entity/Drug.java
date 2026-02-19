package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ilaclar")
public class Drug {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "ilac_adi", nullable = false, length = 150)
    private String ilacAdi;

    @Column(name = "etkin_madde")
    private String etkinMadde;

    @Column(name = "kullanim_sikligi", length = 100)
    private String kullanimSikligi;

    public Drug() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getIlacAdi() {
        return ilacAdi;
    }

    public void setIlacAdi(String ilacAdi) {
        this.ilacAdi = ilacAdi;
    }

    public String getEtkinMadde() {
        return etkinMadde;
    }

    public void setEtkinMadde(String etkinMadde) {
        this.etkinMadde = etkinMadde;
    }

    public String getKullanimSikligi() {
        return kullanimSikligi;
    }

    public void setKullanimSikligi(String kullanimSikligi) {
        this.kullanimSikligi = kullanimSikligi;
    }
}
