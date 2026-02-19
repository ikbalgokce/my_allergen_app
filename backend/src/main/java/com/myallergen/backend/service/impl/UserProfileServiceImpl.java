package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.UserProfileResponse;
import com.myallergen.backend.dto.UserProfileUpdateRequest;
import com.myallergen.backend.entity.User;
import com.myallergen.backend.repository.UserRepository;
import com.myallergen.backend.service.UserProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class UserProfileServiceImpl implements UserProfileService {

    private final UserRepository userRepository;

    @Override
    public UserProfileResponse getProfile(Integer userId) {
        User user = findUserOrThrow(userId);
        return toResponse(user);
    }

    @Override
    public UserProfileResponse updateProfile(Integer userId, UserProfileUpdateRequest request) {
        User user = findUserOrThrow(userId);

        boolean mailTakenByAnother = userRepository.findByMail(request.mail())
                .filter(existing -> !existing.getUserId().equals(userId))
                .isPresent();
        if (mailTakenByAnother) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "MAIL_ALREADY_USED");
        }

        user.setAd(request.ad());
        user.setSoyad(request.soyad());
        user.setMail(request.mail());
        user.setSifre(request.sifre());
        user.setYas(request.yas());

        User saved = userRepository.save(user);
        return toResponse(saved);
    }

    private User findUserOrThrow(Integer userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "USER_NOT_FOUND"));
    }

    private UserProfileResponse toResponse(User user) {
        return new UserProfileResponse(
                user.getUserId(),
                user.getAd(),
                user.getSoyad(),
                user.getMail(),
                user.getSifre(),
                user.getYas()
        );
    }
}
