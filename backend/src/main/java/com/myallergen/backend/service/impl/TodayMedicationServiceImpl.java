package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.TodayMedicationItemResponse;
import com.myallergen.backend.repository.TodayMedicationProjection;
import com.myallergen.backend.repository.UserMedicationRepository;
import com.myallergen.backend.service.TodayMedicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TodayMedicationServiceImpl implements TodayMedicationService {

    private final UserMedicationRepository userMedicationRepository;

    @Override
    public List<TodayMedicationItemResponse> getTodayMedications(Integer userId) {
        List<TodayMedicationProjection> rows = userMedicationRepository.findTodayMedicationRows(userId);
        return rows.stream()
                .map(row -> new TodayMedicationItemResponse(
                        row.getIlacId(),
                        row.getIlacAdi(),
                        row.getIlacDozu(),
                        row.getKullanimSikligi(),
                        row.getHatirlatmaSaati() != null ? row.getHatirlatmaSaati() : "-"
                ))
                .toList();
    }
}
