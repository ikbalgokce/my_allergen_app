package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "kullanicilar")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer userId;

    @Column(name = "ad", length = 100)
    private String ad;

    @Column(name = "soyad", length = 100)
    private String soyad;

    @Column(name = "mail", nullable = false, unique = true, length = 100)
    private String mail;

    @Column(name = "sifre", nullable = false, length = 255)
    private String sifre;

    @Column(name = "kullanici_ad", length = 100)
    private String kullaniciAd;

    @Column(name = "yas")
    private Integer yas;

    @Column(name = "alerjiler", length = 1000)
    private String alerjiler;

    public User() {
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getAd() {
        return ad;
    }

    public void setAd(String ad) {
        this.ad = ad;
    }

    public String getSoyad() {
        return soyad;
    }

    public void setSoyad(String soyad) {
        this.soyad = soyad;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }

    public String getSifre() {
        return sifre;
    }

    public void setSifre(String sifre) {
        this.sifre = sifre;
    }

    public String getKullaniciAd() {
        return kullaniciAd;
    }

    public void setKullaniciAd(String kullaniciAd) {
        this.kullaniciAd = kullaniciAd;
    }

    public Integer getYas() {
        return yas;
    }

    public void setYas(Integer yas) {
        this.yas = yas;
    }

    public String getAlerjiler() {
        return alerjiler;
    }

    public void setAlerjiler(String alerjiler) {
        this.alerjiler = alerjiler;
    }
}
