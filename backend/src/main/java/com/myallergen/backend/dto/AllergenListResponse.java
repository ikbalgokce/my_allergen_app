package com.myallergen.backend.dto;

import java.util.List;

public record AllergenListResponse(
        List<String> allergens
) {
}
