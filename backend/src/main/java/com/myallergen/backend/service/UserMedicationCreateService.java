package com.myallergen.backend.service;

import com.myallergen.backend.dto.TodayMedicationItemResponse;
import com.myallergen.backend.dto.UserMedicationCreateRequest;

public interface UserMedicationCreateService {
    TodayMedicationItemResponse create(Integer userId, UserMedicationCreateRequest request);
}
