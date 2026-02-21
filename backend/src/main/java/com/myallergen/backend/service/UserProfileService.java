package com.myallergen.backend.service;

import com.myallergen.backend.dto.UserProfileResponse;
import com.myallergen.backend.dto.UserProfileUpdateRequest;

public interface UserProfileService {
    UserProfileResponse getProfile(Integer userId);

    UserProfileResponse updateProfile(Integer userId, UserProfileUpdateRequest request);
}
