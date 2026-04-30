package com.cardapiu.demo.dtos;

import jakarta.validation.constraints.NotBlank;

public record EntregadorRequestDTO(
        @NotBlank String placaVeiculo,
        @NotBlank String telefone,
        Long usuarioId
) {}
