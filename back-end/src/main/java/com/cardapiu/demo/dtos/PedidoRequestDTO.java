package com.cardapiu.demo.dtos;

import com.cardapiu.demo.models.TipoEntrega; // Importando o novo enum
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public record PedidoRequestDTO(
        @NotNull(message = "O ID do restaurante é obrigatório")
        Long restauranteId, // ID do restaurante
        @NotEmpty List<ItemPedidoRequestDTO> itens,
        String observacao,
        @NotNull(message = "O tipo de entrega é obrigatório")
        TipoEntrega tipoEntrega // Adicionado: Tipo de entrega (ENTREGA ou RETIRADA_NO_LOCAL)
) {}