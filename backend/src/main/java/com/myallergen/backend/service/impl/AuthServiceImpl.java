package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.LoginRequest;
import com.myallergen.backend.dto.LoginResponse;
import com.myallergen.backend.dto.RegisterRequest;
import com.myallergen.backend.entity.User;
import com.myallergen.backend.exception.AuthException;
import com.myallergen.backend.repository.UserRepository;
import com.myallergen.backend.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthServiceImpl.class);

    private final UserRepository userRepository;

    @Override
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByMail(request.mail()).orElse(null);
        if (user == null) {
            log.info("USER NOT FOUND");
            throw new AuthException(HttpStatus.NOT_FOUND, "MAIL_WRONG", "MAIL_WRONG");
        }
        log.info("USER FOUND");

        // TODO: Password hashing'e gecildiginde burada plain text yerine hash karsilastirmasi yap.
        if (!user.getSifre().equals(request.sifre())) {
            throw new AuthException(HttpStatus.UNAUTHORIZED, "PASSWORD_WRONG", "PASSWORD_WRONG");
        }

        return new LoginResponse(
                true,
                "LOGIN_SUCCESS",
                "LOGIN_SUCCESS",
                user.getUserId(),
                user.getAd(),
                user.getSoyad()
        );
    }

    @Override
    public LoginResponse register(RegisterRequest request) {
        if (userRepository.findByMail(request.mail()).isPresent()) {
            throw new AuthException(HttpStatus.CONFLICT, "MAIL_EXISTS", "MAIL_EXISTS");
        }

        User user = new User();
        user.setAd(request.ad().trim());
        user.setSoyad(request.soyad().trim());
        user.setMail(request.mail().trim());
        user.setSifre(request.sifre());
        user.setKullaniciAd(request.kullaniciAd().trim());
        user.setYas(request.yas());

        User saved = userRepository.save(user);

        return new LoginResponse(
                true,
                "REGISTER_SUCCESS",
                "REGISTER_SUCCESS",
                saved.getUserId(),
                saved.getAd(),
                saved.getSoyad()
        );
    }
}
