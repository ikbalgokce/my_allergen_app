package com.myallergen.backend.controller;

import com.myallergen.backend.dto.DrugInformationResponse;
import com.myallergen.backend.service.DrugInformationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/drugs")
@RequiredArgsConstructor
public class DrugInformationController {

    private final DrugInformationService drugInformationService;

    @GetMapping("/{drugId}/information")
    public DrugInformationResponse getDrugInformation(@PathVariable Integer drugId) {
        return drugInformationService.getDrugInformation(drugId);
    }
}
