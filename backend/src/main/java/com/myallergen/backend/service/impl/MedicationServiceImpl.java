package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.MedicationItemResponse;
import com.myallergen.backend.dto.MedicationRequest;
import com.myallergen.backend.entity.Medication;
import com.myallergen.backend.repository.MedicationRepository;
import com.myallergen.backend.service.MedicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MedicationServiceImpl implements MedicationService {

    private final MedicationRepository medicationRepository;

    @Override
    public List<MedicationItemResponse> getAll() {
        return medicationRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    public MedicationItemResponse getById(Integer id) {
        Medication medication = getMedicationOrThrow(id);
        return toResponse(medication);
    }

    @Override
    public MedicationItemResponse create(MedicationRequest request) {
        Medication medication = Medication.builder()
                .ilacAdi(request.ilacAdi())
                .ilacDozu(request.ilacDozu())
                .kullanimSikligi(request.kullanimSikligi())
                .hatirlatmaSaati(request.hatirlatmaSaati())
                .build();

        Medication saved = medicationRepository.save(medication);
        return toResponse(saved);
    }

    @Override
    public MedicationItemResponse update(Integer id, MedicationRequest request) {
        Medication medication = getMedicationOrThrow(id);
        medication.setIlacAdi(request.ilacAdi());
        medication.setIlacDozu(request.ilacDozu());
        medication.setKullanimSikligi(request.kullanimSikligi());
        medication.setHatirlatmaSaati(request.hatirlatmaSaati());

        Medication updated = medicationRepository.save(medication);
        return toResponse(updated);
    }

    @Override
    public void delete(Integer id) {
        Medication medication = getMedicationOrThrow(id);
        medicationRepository.delete(medication);
    }

    private Medication getMedicationOrThrow(Integer id) {
        return medicationRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Ilac bulunamadi"));
    }

    private MedicationItemResponse toResponse(Medication medication) {
        return new MedicationItemResponse(
                medication.getIlacId(),
                medication.getIlacAdi(),
                medication.getIlacDozu(),
                medication.getKullanimSikligi(),
                medication.getHatirlatmaSaati()
        );
    }
}
