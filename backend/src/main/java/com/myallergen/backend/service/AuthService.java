package com.myallergen.backend.service;

import com.myallergen.backend.dto.LoginRequest;
import com.myallergen.backend.dto.LoginResponse;

public interface AuthService {
    LoginResponse login(LoginRequest request);
}
