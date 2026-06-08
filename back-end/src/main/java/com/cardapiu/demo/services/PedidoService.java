package com.cardapiu.demo.services;

import com.cardapiu.demo.dtos.PedidoResponseDTO;
import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.Entrega;
import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.repositories.EntregaRepository;
import com.cardapiu.demo.repositories.PedidoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;

    @Autowired
    private EntregaRepository entregaRepository;

    public Pedido atualizarStatus(Long id, UpdateStatusDTO data) {
        Pedido pedido = pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        pedido.setStatus(data.status());
        return pedidoRepository.save(pedido);
    }

    public Pedido buscarPorId(Long id) {
        return pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));
    }

    public PedidoResponseDTO buscarPedidoParaRastreio(Long pedidoId) {
        Pedido pedido = pedidoRepository.findById(pedidoId)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        // Busca a entrega associada a este pedido
        Optional<Entrega> entregaOptional = entregaRepository.findByPedidoId(pedidoId);

        // Se a entrega existir, usamos o ID dela. Se não, usamos null.
        Long entregaId = entregaOptional.map(Entrega::getId).orElse(null);

        return new PedidoResponseDTO(pedido, entregaId);
    }
}
