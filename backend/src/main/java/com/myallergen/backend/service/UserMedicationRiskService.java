package com.myallergen.backend.service;

import com.myallergen.backend.dto.HomeRiskWarningResponse;

public interface UserMedicationRiskService {
    HomeRiskWarningResponse checkRisk(Integer userId);
}
