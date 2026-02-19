package com.myallergen.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "ilaclar")
@Getter
@Setter
public class Drug {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "ilac_adi", nullable = false, length = 150)
    private String ilacAdi;
}
