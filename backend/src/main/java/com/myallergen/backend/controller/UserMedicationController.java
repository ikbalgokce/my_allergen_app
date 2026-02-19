package com.myallergen.backend.controller;

import com.myallergen.backend.dto.TodayMedicationItemResponse;
import com.myallergen.backend.service.TodayMedicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserMedicationController {

    private final TodayMedicationService todayMedicationService;

    @GetMapping("/{userId}/today-medications")
    public List<TodayMedicationItemResponse> getTodayMedications(@PathVariable Integer userId) {
        return todayMedicationService.getTodayMedications(userId);
    }
}
