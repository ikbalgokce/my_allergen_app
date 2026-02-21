package com.myallergen.backend.service;

import com.myallergen.backend.dto.MedicationItemResponse;
import com.myallergen.backend.dto.MedicationRequest;

import java.util.List;

public interface MedicationService {
    List<MedicationItemResponse> getAll();

    MedicationItemResponse getById(Integer id);

    MedicationItemResponse create(MedicationRequest request);

    MedicationItemResponse update(Integer id, MedicationRequest request);

    void delete(Integer id);
}
