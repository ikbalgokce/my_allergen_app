package com.myallergen.backend.controller;

import com.myallergen.backend.dto.UserProfileResponse;
import com.myallergen.backend.dto.UserProfileUpdateRequest;
import com.myallergen.backend.service.UserProfileService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping("/{userId}/profile")
    public UserProfileResponse getProfile(@PathVariable Integer userId) {
        return userProfileService.getProfile(userId);
    }

    @PutMapping("/{userId}/profile")
    public UserProfileResponse updateProfile(
            @PathVariable Integer userId,
            @Valid @RequestBody UserProfileUpdateRequest request
    ) {
        return userProfileService.updateProfile(userId, request);
    }
}
