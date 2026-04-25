package com.cardapiu.demo.controllers;

import com.cardapiu.demo.dtos.PedidoRequestDTO;
import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.services.PedidoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("pedidos")
public class PedidoController {

    @Autowired
    private PedidoService service;

    // Rota para o Cliente fazer o pedido
    // No seu SecurityConfigurations, esta rota deve ser .permitAll()
    @PostMapping
    public ResponseEntity criarPedido(@RequestBody @Valid PedidoRequestDTO data) {
        // No futuro, aqui chamaremos o service para salvar os itens
        return ResponseEntity.ok("Pedido recebido com sucesso! Status: PENDENTE");
    }

    // Rota para o Cliente acompanhar o status do pedido dele
    @GetMapping("/{id}")
    public ResponseEntity<Pedido> buscarPedido(@PathVariable Long id) {
        return ResponseEntity.ok(service.buscarPorId(id));
    }

    // Rota para o DONO alterar o status (Confirmar, Cancelar, etc)
    // Esta rota deve exigir o Token JWT no SecurityConfigurations
    @PatchMapping("/{id}/status")
    public ResponseEntity atualizarStatus(@PathVariable Long id, @RequestBody @Valid UpdateStatusDTO data) {
        Pedido pedidoAtualizado = service.atualizarStatus(id, data);
        return ResponseEntity.ok(pedidoAtualizado);
    }
}