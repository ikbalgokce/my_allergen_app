package com.myallergen.backend.service;

import com.myallergen.backend.dto.DrugInformationResponse;

public interface DrugInformationService {
    DrugInformationResponse getDrugInformation(Integer drugId);
}
