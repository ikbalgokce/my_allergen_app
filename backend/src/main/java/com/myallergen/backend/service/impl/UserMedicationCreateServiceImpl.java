package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.TodayMedicationItemResponse;
import com.myallergen.backend.dto.UserMedicationCreateRequest;
import com.myallergen.backend.entity.Drug;
import com.myallergen.backend.entity.UserMedication;
import com.myallergen.backend.entity.UserMedicationId;
import com.myallergen.backend.repository.DrugRepository;
import com.myallergen.backend.repository.UserMedicationRepository;
import com.myallergen.backend.repository.UserRepository;
import com.myallergen.backend.service.UserMedicationCreateService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class UserMedicationCreateServiceImpl implements UserMedicationCreateService {

    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private static final Pattern NUMBER_PATTERN = Pattern.compile("(\\d+)");
    private static final List<DateTimeFormatter> DATE_FORMATTERS = List.of(
            DateTimeFormatter.ISO_LOCAL_DATE,
            DateTimeFormatter.ofPattern("dd.MM.yyyy"),
            DateTimeFormatter.ofPattern("dd/MM/yyyy")
    );

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

        String ilacAdi = request.ilacAdi().trim();
        Drug savedDrug = drugRepository.findFirstByIlacAdiIgnoreCase(ilacAdi)
                .orElseGet(() -> {
                    Drug newDrug = new Drug();
                    newDrug.setIlacAdi(ilacAdi);
                    newDrug.setKullanimSikligi(request.kullanimSikligi());
                    return drugRepository.save(newDrug);
                });

        String hatirlatma = normalizeReminderTimes(request.hatirlatmaSaati());
        LocalDate baslangicTarihi = LocalDate.now();
        LocalDate bitisTarihi = calculateBitisTarihi(baslangicTarihi, savedDrug.getSureSiniri());

        UserMedication userMedication = new UserMedication();
        userMedication.setKullaniciId(userId);
        userMedication.setIlacId(savedDrug.getId());
        userMedication.setIlacDozu(request.ilacDozu());
        userMedication.setKullanimSikligi(request.kullanimSikligi());
        userMedication.setHatirlatmaSaati(hatirlatma);
        userMedication.setBaslangicTarihi(baslangicTarihi);
        userMedication.setBitisTarihi(bitisTarihi);
        userMedicationRepository.save(userMedication);

        return new TodayMedicationItemResponse(
                savedDrug.getId(),
                savedDrug.getIlacAdi(),
                userMedication.getIlacDozu(),
                userMedication.getKullanimSikligi(),
                hatirlatma != null ? hatirlatma : "-",
                baslangicTarihi.toString(),
                bitisTarihi != null ? bitisTarihi.toString() : "-",
                savedDrug.getSureSiniri()
        );
    }

    @Override
    public void delete(Integer userId, Integer ilacId) {
        UserMedicationId id = new UserMedicationId(userId, ilacId);
        UserMedication userMedication = userMedicationRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "USER_MEDICATION_NOT_FOUND"));
        userMedicationRepository.delete(userMedication);
    }

    private String normalizeReminderTimes(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return null;
        }

        String[] parts = raw.split(",");
        StringBuilder normalized = new StringBuilder();
        for (String part : parts) {
            String p = part.trim();
            if (p.isEmpty()) continue;
            try {
                DateTimeFormatter parser = DateTimeFormatter.ofPattern("H:mm");
                String formatted = parser.parse(p, java.time.LocalTime::from).format(TIME_FORMATTER);
                if (!normalized.isEmpty()) {
                    normalized.append(",");
                }
                normalized.append(formatted);
            } catch (DateTimeParseException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "INVALID_TIME_FORMAT");
            }
        }

        if (normalized.isEmpty()) {
            return null;
        }
        return normalized.toString();
    }

    private LocalDate calculateBitisTarihi(LocalDate baslangicTarihi, String sureSiniriRaw) {
        if (sureSiniriRaw == null || sureSiniriRaw.trim().isEmpty()) {
            return null;
        }

        String normalized = sureSiniriRaw.trim();
        Matcher matcher = NUMBER_PATTERN.matcher(normalized);
        if (matcher.find()) {
            int gun = Integer.parseInt(matcher.group(1));
            if (gun > 0) {
                return baslangicTarihi.plusDays(gun);
            }
        }

        for (DateTimeFormatter formatter : DATE_FORMATTERS) {
            try {
                return LocalDate.parse(normalized, formatter);
            } catch (DateTimeParseException ignored) {
            }
        }

        return null;
    }
}
