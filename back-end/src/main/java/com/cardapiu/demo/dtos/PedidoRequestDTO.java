package com.cardapiu.demo.dtos;

import jakarta.validation.constraints.NotEmpty;
import java.util.List;

public record PedidoRequestDTO(
        @NotEmpty List<ItemPedidoRequestDTO> itens,
        String observacao
) {}