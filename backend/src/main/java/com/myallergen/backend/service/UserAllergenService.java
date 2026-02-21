package com.myallergen.backend.service;

import java.util.List;

public interface UserAllergenService {
    List<String> getAllergens(Integer userId);

    List<String> addAllergen(Integer userId, String allergenName);

    List<String> removeAllergen(Integer userId, String allergenName);
}
