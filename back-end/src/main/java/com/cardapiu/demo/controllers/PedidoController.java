package com.cardapiu.demo.controllers;

import com.cardapiu.demo.dtos.PedidoRequestDTO;
import com.cardapiu.demo.dtos.PedidoResponseDTO;
import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.services.PedidoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("pedidos")
public class PedidoController {

    @Autowired
    private PedidoService service;

    // Rota para o Cliente fazer o pedido
    @PostMapping
    public ResponseEntity criarPedido(@RequestBody @Valid PedidoRequestDTO data) {
        // No futuro, aqui chamaremos o service para salvar os itens
        return ResponseEntity.ok("Pedido recebido com sucesso! Status: PENDENTE");
    }

    // Rota para o Cliente acompanhar o status do pedido dele
    @GetMapping("/{id}")
    public ResponseEntity<PedidoResponseDTO> buscarPedido(@PathVariable Long id) {
        // Agora retorna o DTO que contém o ID da entrega para o rastreamento via Firebase
        PedidoResponseDTO pedidoResponse = service.buscarPedidoParaRastreio(id);
        return ResponseEntity.ok(pedidoResponse);
    }

    // Rota para o DONO alterar o status (Confirmar, Cancelar, etc)
    @PatchMapping("/{id}/status")
    public ResponseEntity<Pedido> atualizarStatus(@PathVariable Long id, @RequestBody @Valid UpdateStatusDTO data) {
        Pedido pedidoAtualizado = service.atualizarStatus(id, data);
        return ResponseEntity.ok(pedidoAtualizado);
    }
}
