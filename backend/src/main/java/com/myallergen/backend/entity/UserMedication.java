package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "kullanici_ilac")
@IdClass(UserMedicationId.class)
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

    public UserMedication() {
    }

    public Integer getKullaniciId() {
        return kullaniciId;
    }

    public void setKullaniciId(Integer kullaniciId) {
        this.kullaniciId = kullaniciId;
    }

    public Integer getIlacId() {
        return ilacId;
    }

    public void setIlacId(Integer ilacId) {
        this.ilacId = ilacId;
    }

    public String getIlacDozu() {
        return ilacDozu;
    }

    public void setIlacDozu(String ilacDozu) {
        this.ilacDozu = ilacDozu;
    }

    public LocalDate getBaslangicTarihi() {
        return baslangicTarihi;
    }

    public void setBaslangicTarihi(LocalDate baslangicTarihi) {
        this.baslangicTarihi = baslangicTarihi;
    }

    public LocalDate getBitisTarihi() {
        return bitisTarihi;
    }

    public void setBitisTarihi(LocalDate bitisTarihi) {
        this.bitisTarihi = bitisTarihi;
    }

    public String getKullanimSikligi() {
        return kullanimSikligi;
    }

    public void setKullanimSikligi(String kullanimSikligi) {
        this.kullanimSikligi = kullanimSikligi;
    }

    public LocalTime getHatirlatmaSaati() {
        return hatirlatmaSaati;
    }

    public void setHatirlatmaSaati(LocalTime hatirlatmaSaati) {
        this.hatirlatmaSaati = hatirlatmaSaati;
    }
}
