package com.myallergen.backend.dto;

import java.util.List;

public record HomeRiskWarningResponse(
        boolean risk,
        String message,
        List<String> matchedItems
) {
}
