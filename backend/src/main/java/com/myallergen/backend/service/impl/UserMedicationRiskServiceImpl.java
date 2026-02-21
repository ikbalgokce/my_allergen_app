package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.HomeRiskWarningResponse;
import com.myallergen.backend.entity.User;
import com.myallergen.backend.repository.UserMedicationRepository;
import com.myallergen.backend.repository.UserMedicationRiskProjection;
import com.myallergen.backend.repository.UserRepository;
import com.myallergen.backend.service.UserMedicationRiskService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

@Service
public class UserMedicationRiskServiceImpl implements UserMedicationRiskService {

    private final UserRepository userRepository;
    private final UserMedicationRepository userMedicationRepository;

    public UserMedicationRiskServiceImpl(UserRepository userRepository, UserMedicationRepository userMedicationRepository) {
        this.userRepository = userRepository;
        this.userMedicationRepository = userMedicationRepository;
    }

    @Override
    public HomeRiskWarningResponse checkRisk(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "USER_NOT_FOUND"));

        List<String> allergens = splitCommaValues(user.getAlerjiler());
        if (allergens.isEmpty()) {
            return new HomeRiskWarningResponse(false, "", List.of());
        }

        List<UserMedicationRiskProjection> rows = userMedicationRepository.findRiskRows(userId);
        List<String> matchedItems = new ArrayList<>();

        for (UserMedicationRiskProjection row : rows) {
            String etkinMadde = safeLower(row.getEtkinMadde());
            if (etkinMadde.isEmpty()) continue;

            for (String allergen : allergens) {
                String normalizedAllergen = safeLower(allergen);
                if (normalizedAllergen.isEmpty()) continue;

                // Eslestirme: etken madde alaninda alerjen metni geciyorsa risk var.
                if (etkinMadde.contains(normalizedAllergen)) {
                    matchedItems.add(row.getIlacAdi() + " / " + allergen);
                    break;
                }
            }
        }

        if (matchedItems.isEmpty()) {
            return new HomeRiskWarningResponse(false, "", List.of());
        }

        return new HomeRiskWarningResponse(
                true,
                "Bu ilaci kullanmaniz tehlikeli. Lutfen kullanmadan once doktorunuza danisin.",
                matchedItems
        );
    }

    private List<String> splitCommaValues(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return List.of();
        }
        return Arrays.stream(raw.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }

    private String safeLower(String s) {
        return s == null ? "" : s.toLowerCase(Locale.ROOT).trim();
    }
}
