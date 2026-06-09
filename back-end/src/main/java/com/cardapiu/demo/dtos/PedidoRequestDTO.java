package com.cardapiu.demo.dtos;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public record PedidoRequestDTO(
        @NotNull(message = "O ID do restaurante é obrigatório")
        Long restauranteId, // Adicionado: ID do restaurante
        @NotEmpty List<ItemPedidoRequestDTO> itens,
        String observacao
) {}