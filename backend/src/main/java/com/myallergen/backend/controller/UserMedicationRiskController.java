package com.myallergen.backend.controller;

import com.myallergen.backend.dto.HomeRiskWarningResponse;
import com.myallergen.backend.service.UserMedicationRiskService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
public class UserMedicationRiskController {

    private final UserMedicationRiskService userMedicationRiskService;

    public UserMedicationRiskController(UserMedicationRiskService userMedicationRiskService) {
        this.userMedicationRiskService = userMedicationRiskService;
    }

    @GetMapping("/{userId}/risk-warning")
    public HomeRiskWarningResponse getRiskWarning(@PathVariable Integer userId) {
        return userMedicationRiskService.checkRisk(userId);
    }
}
