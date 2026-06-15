package com.cardapiu.demo.dtos;

import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.models.StatusPedido;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public record PedidoResponseDTO(
        Long id,
        LocalDateTime dataCriacao,
        StatusPedido status,
        Double valorTotal,
        String observacao,
        Long entregaId,
        List<ItemPedidoResponseDTO> itens
) {
    public PedidoResponseDTO(Pedido pedido, Long entregaId) {
        this(
                pedido.getId(),
                pedido.getDataCriacao(),
                pedido.getStatus(),
                pedido.getValorTotal(),
                pedido.getObservacao(),
                entregaId,
                pedido.getItens().stream()
                        .map(item -> new ItemPedidoResponseDTO(
                                item.getProduto().getNome(),
                                item.getQuantidade(),
                                item.getPrecoUnitario()))
                        .collect(Collectors.toList())
        );
    }
}
