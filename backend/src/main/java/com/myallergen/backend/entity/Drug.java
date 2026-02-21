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

    @Column(name = "kisa_bilgi")
    private String kisaBilgi;

    @Column(name = "uyari_proaktif_not")
    private String uyariProaktifNot;

    @Column(name = "sure_siniri", length = 100)
    private String sureSiniri;

    @Column(name = "ilac_besin_etkilesimi")
    private String ilacBesinEtkilesimi;

    @Column(name = "ilac_yasam_tarzi_etkilesimi")
    private String ilacYasamTarziEtkilesimi;

    @Column(name = "uygulama_sekli", length = 100)
    private String uygulamaSekli;

    @Column(name = "ilac_ilac_cakismasi")
    private String ilacIlacCakismasi;

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

    public String getKisaBilgi() {
        return kisaBilgi;
    }

    public void setKisaBilgi(String kisaBilgi) {
        this.kisaBilgi = kisaBilgi;
    }

    public String getUyariProaktifNot() {
        return uyariProaktifNot;
    }

    public void setUyariProaktifNot(String uyariProaktifNot) {
        this.uyariProaktifNot = uyariProaktifNot;
    }

    public String getSureSiniri() {
        return sureSiniri;
    }

    public void setSureSiniri(String sureSiniri) {
        this.sureSiniri = sureSiniri;
    }

    public String getIlacBesinEtkilesimi() {
        return ilacBesinEtkilesimi;
    }

    public void setIlacBesinEtkilesimi(String ilacBesinEtkilesimi) {
        this.ilacBesinEtkilesimi = ilacBesinEtkilesimi;
    }

    public String getIlacYasamTarziEtkilesimi() {
        return ilacYasamTarziEtkilesimi;
    }

    public void setIlacYasamTarziEtkilesimi(String ilacYasamTarziEtkilesimi) {
        this.ilacYasamTarziEtkilesimi = ilacYasamTarziEtkilesimi;
    }

    public String getUygulamaSekli() {
        return uygulamaSekli;
    }

    public void setUygulamaSekli(String uygulamaSekli) {
        this.uygulamaSekli = uygulamaSekli;
    }

    public String getIlacIlacCakismasi() {
        return ilacIlacCakismasi;
    }

    public void setIlacIlacCakismasi(String ilacIlacCakismasi) {
        this.ilacIlacCakismasi = ilacIlacCakismasi;
    }
}
