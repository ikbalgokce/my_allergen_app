package com.myallergen.backend.service.impl;

import com.myallergen.backend.entity.User;
import com.myallergen.backend.repository.DrugRepository;
import com.myallergen.backend.repository.UserRepository;
import com.myallergen.backend.service.UserAllergenService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Arrays;
import java.util.List;

@Service
public class UserAllergenServiceImpl implements UserAllergenService {

    private final UserRepository userRepository;
    private final DrugRepository drugRepository;

    public UserAllergenServiceImpl(UserRepository userRepository, DrugRepository drugRepository) {
        this.userRepository = userRepository;
        this.drugRepository = drugRepository;
    }

    @Override
    public List<String> getAllergens(Integer userId) {
        User user = findUserOrThrow(userId);
        return splitAllergens(user.getAlerjiler());
    }

    @Override
    public List<String> addAllergen(Integer userId, String allergenName) {
        User user = findUserOrThrow(userId);
        List<String> current = splitAllergens(user.getAlerjiler());

        String normalized = allergenName == null ? "" : allergenName.trim();
        if (normalized.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "ALLERGEN_NAME_REQUIRED");
        }

        boolean validAllergen = drugRepository.existsByIlacAdiOrEtkinMaddeContains(normalized);
        if (!validAllergen) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "ALLERGEN_NOT_FOUND");
        }

        boolean exists = current.stream().anyMatch(item -> item.equalsIgnoreCase(normalized));
        List<String> updated = exists
                ? current
                : java.util.stream.Stream.concat(current.stream(), java.util.stream.Stream.of(normalized)).toList();

        user.setAlerjiler(String.join(", ", updated));
        userRepository.save(user);
        return updated;
    }

    @Override
    public List<String> removeAllergen(Integer userId, String allergenName) {
        User user = findUserOrThrow(userId);
        List<String> current = splitAllergens(user.getAlerjiler());

        List<String> updated = current.stream()
                .filter(item -> !item.equalsIgnoreCase(allergenName.trim()))
                .toList();

        user.setAlerjiler(String.join(", ", updated));
        userRepository.save(user);
        return updated;
    }

    private User findUserOrThrow(Integer userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "USER_NOT_FOUND"));
    }

    private List<String> splitAllergens(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return List.of();
        }
        return Arrays.stream(raw.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }
}
