package com.myallergen.backend.service;

import com.myallergen.backend.dto.LoginRequest;
import com.myallergen.backend.dto.LoginResponse;
import com.myallergen.backend.dto.RegisterRequest;

public interface AuthService {
    LoginResponse login(LoginRequest request);

    LoginResponse register(RegisterRequest request);
}
