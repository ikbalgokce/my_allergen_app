package com.myallergen.backend.controller;

import com.myallergen.backend.dto.TodayMedicationItemResponse;
import com.myallergen.backend.dto.UserMedicationCreateRequest;
import com.myallergen.backend.service.UserMedicationCreateService;
import com.myallergen.backend.service.TodayMedicationService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserMedicationController {

    private final TodayMedicationService todayMedicationService;
    private final UserMedicationCreateService userMedicationCreateService;

    public UserMedicationController(
            TodayMedicationService todayMedicationService,
            UserMedicationCreateService userMedicationCreateService
    ) {
        this.todayMedicationService = todayMedicationService;
        this.userMedicationCreateService = userMedicationCreateService;
    }

    @GetMapping("/{userId}/today-medications")
    public List<TodayMedicationItemResponse> getTodayMedications(@PathVariable Integer userId) {
        return todayMedicationService.getTodayMedications(userId);
    }

    @PostMapping("/{userId}/medications")
    @ResponseStatus(HttpStatus.CREATED)
    public TodayMedicationItemResponse createMedication(
            @PathVariable Integer userId,
            @Valid @RequestBody UserMedicationCreateRequest request
    ) {
        return userMedicationCreateService.create(userId, request);
    }

    @DeleteMapping("/{userId}/medications/{ilacId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteMedication(
            @PathVariable Integer userId,
            @PathVariable Integer ilacId
    ) {
        userMedicationCreateService.delete(userId, ilacId);
    }
}
