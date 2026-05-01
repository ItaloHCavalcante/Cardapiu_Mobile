package com.cardapiu.demo.dtos;

import com.cardapiu.demo.models.UserRole;
import jakarta.validation.constraints.NotBlank;

public record RegisterDTO(
        @NotBlank String login,
        @NotBlank String senha,
        UserRole role
) {
}