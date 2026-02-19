package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.TodayMedicationItemResponse;
import com.myallergen.backend.dto.UserMedicationCreateRequest;
import com.myallergen.backend.entity.Drug;
import com.myallergen.backend.entity.UserMedication;
import com.myallergen.backend.repository.DrugRepository;
import com.myallergen.backend.repository.UserMedicationRepository;
import com.myallergen.backend.repository.UserRepository;
import com.myallergen.backend.service.UserMedicationCreateService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@Service
public class UserMedicationCreateServiceImpl implements UserMedicationCreateService {

    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    private final UserRepository userRepository;
    private final DrugRepository drugRepository;
    private final UserMedicationRepository userMedicationRepository;

    public UserMedicationCreateServiceImpl(
            UserRepository userRepository,
            DrugRepository drugRepository,
            UserMedicationRepository userMedicationRepository
    ) {
        this.userRepository = userRepository;
        this.drugRepository = drugRepository;
        this.userMedicationRepository = userMedicationRepository;
    }

    @Override
    public TodayMedicationItemResponse create(Integer userId, UserMedicationCreateRequest request) {
        userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "USER_NOT_FOUND"));

        Drug drug = new Drug();
        drug.setIlacAdi(request.ilacAdi().trim());
        drug.setKullanimSikligi(request.kullanimSikligi());
        Drug savedDrug = drugRepository.save(drug);

        LocalTime hatirlatma = parseTimeOrNull(request.hatirlatmaSaati());

        UserMedication userMedication = new UserMedication();
        userMedication.setKullaniciId(userId);
        userMedication.setIlacId(savedDrug.getId());
        userMedication.setIlacDozu(request.ilacDozu());
        userMedication.setKullanimSikligi(request.kullanimSikligi());
        userMedication.setHatirlatmaSaati(hatirlatma);
        userMedication.setBaslangicTarihi(LocalDate.now());
        userMedicationRepository.save(userMedication);

        return new TodayMedicationItemResponse(
                savedDrug.getId(),
                savedDrug.getIlacAdi(),
                userMedication.getIlacDozu(),
                userMedication.getKullanimSikligi(),
                hatirlatma != null ? hatirlatma.format(TIME_FORMATTER) : "-"
        );
    }

    private LocalTime parseTimeOrNull(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalTime.parse(raw, TIME_FORMATTER);
        } catch (DateTimeParseException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "INVALID_TIME_FORMAT");
        }
    }
}
