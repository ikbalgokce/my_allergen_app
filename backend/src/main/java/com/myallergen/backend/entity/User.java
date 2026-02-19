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
@Table(name = "kullanicilar")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
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
}
