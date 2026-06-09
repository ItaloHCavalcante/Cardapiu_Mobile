package com.cardapiu.demo.services;

import com.cardapiu.demo.dtos.PedidoResponseDTO;
import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.Entrega;
import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.models.StatusPedido;
import com.cardapiu.demo.models.Usuario;
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

    @Autowired
    private NotificationService notificationService; // Injetando o serviço de notificação

    public Pedido atualizarStatus(Long id, UpdateStatusDTO data) {
        Pedido pedido = pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        pedido.setStatus(data.status());
        Pedido pedidoAtualizado = pedidoRepository.save(pedido);

        // Lógica para enviar a notificação
        enviarNotificacaoDeStatus(pedidoAtualizado);

        return pedidoAtualizado;
    }

    private void enviarNotificacaoDeStatus(Pedido pedido) {
        Usuario cliente = pedido.getCliente();
        if (cliente == null || cliente.getFcmToken() == null) {
            return; // Não faz nada se não houver cliente ou token
        }

        String fcmToken = cliente.getFcmToken();
        String titulo = "Atualização do seu Pedido!";
        String corpo = "";

        if (pedido.getStatus() == StatusPedido.SAIU_PARA_ENTREGA) {
            corpo = "Seu pedido saiu para entrega!";
        } else if (pedido.getStatus() == StatusPedido.ENTREGUE) {
            corpo = "Seu pedido foi entregue! Bom apetite!";
        }

        if (!corpo.isEmpty()) {
            notificationService.enviarNotificacao(fcmToken, titulo, corpo);
        }
    }

    public Pedido buscarPorId(Long id) {
        return pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));
    }

    public PedidoResponseDTO buscarPedidoParaRastreio(Long pedidoId) {
        Pedido pedido = pedidoRepository.findById(pedidoId)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        Optional<Entrega> entregaOptional = entregaRepository.findByPedidoId(pedidoId);
        Long entregaId = entregaOptional.map(Entrega::getId).orElse(null);

        return new PedidoResponseDTO(pedido, entregaId);
    }
}
