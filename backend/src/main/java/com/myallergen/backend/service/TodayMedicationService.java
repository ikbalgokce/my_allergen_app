package com.myallergen.backend.service;

import com.myallergen.backend.dto.TodayMedicationItemResponse;

import java.util.List;

public interface TodayMedicationService {
    List<TodayMedicationItemResponse> getTodayMedications(Integer userId);
}
