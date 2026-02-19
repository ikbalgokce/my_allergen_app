package com.myallergen.backend.controller;

import com.myallergen.backend.dto.AddAllergenRequest;
import com.myallergen.backend.dto.AllergenListResponse;
import com.myallergen.backend.service.UserAllergenService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserAllergenController {

    private final UserAllergenService userAllergenService;

    public UserAllergenController(UserAllergenService userAllergenService) {
        this.userAllergenService = userAllergenService;
    }

    @GetMapping("/{userId}/allergens")
    public AllergenListResponse getAllergens(@PathVariable Integer userId) {
        List<String> allergens = userAllergenService.getAllergens(userId);
        return new AllergenListResponse(allergens);
    }

    @PostMapping("/{userId}/allergens")
    public AllergenListResponse addAllergen(
            @PathVariable Integer userId,
            @Valid @RequestBody AddAllergenRequest request
    ) {
        List<String> allergens = userAllergenService.addAllergen(userId, request.name());
        return new AllergenListResponse(allergens);
    }

    @DeleteMapping("/{userId}/allergens")
    public AllergenListResponse removeAllergen(
            @PathVariable Integer userId,
            @RequestParam("name") String allergenName
    ) {
        List<String> allergens = userAllergenService.removeAllergen(userId, allergenName);
        return new AllergenListResponse(allergens);
    }
}
