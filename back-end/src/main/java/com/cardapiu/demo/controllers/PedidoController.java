package com.cardapiu.demo.controllers;

import com.cardapiu.demo.dtos.PedidoRequestDTO;
import com.cardapiu.demo.dtos.PedidoResponseDTO;
import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.models.Usuario;
import com.cardapiu.demo.services.PedidoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("pedidos")
public class PedidoController {

    @Autowired
    private PedidoService service;

    // Rota para o Cliente fazer o pedido
    @PostMapping
    public ResponseEntity<Pedido> criarPedido(@RequestBody @Valid PedidoRequestDTO data) {
        // Obtém o usuário autenticado do contexto de segurança
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Usuario cliente = (Usuario) authentication.getPrincipal(); // O principal é o nosso objeto Usuario

        // Chama o serviço para criar o pedido, passando o DTO e o cliente
        Pedido novoPedido = service.criarPedido(data, cliente);
        
        // Retorna o pedido criado, que agora terá o ID
        return ResponseEntity.ok(novoPedido);
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
