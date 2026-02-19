package com.myallergen.backend.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class UserMedicationId implements Serializable {
    private Integer kullaniciId;
    private Integer ilacId;
}
