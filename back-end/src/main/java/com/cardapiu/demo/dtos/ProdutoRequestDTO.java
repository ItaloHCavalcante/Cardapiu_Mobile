package com.cardapiu.demo.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ProdutoRequestDTO(
        @NotBlank String nome,
        String descricao,
        @NotNull Double preco,
        String urlImage,
        Long categoriaId, // Opcional, se houver categoria
        @NotNull Long restauranteId // ID do restaurante ao qual o produto pertence
) {}
