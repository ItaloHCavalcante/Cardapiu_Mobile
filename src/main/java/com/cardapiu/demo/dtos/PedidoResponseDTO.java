package com.cardapiu.demo.dtos;

import com.cardapiu.demo.models.StatusPedido;
import java.time.LocalDateTime;
import java.util.List;

public record PedidoResponseDTO(
        Long id,
        LocalDateTime dataCriacao,
        StatusPedido status,
        List<ItemPedidoResponseDTO> itens,
        Double valorTotal,
        String observacao
) {}