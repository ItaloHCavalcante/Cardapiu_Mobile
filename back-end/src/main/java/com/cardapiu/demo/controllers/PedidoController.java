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

import java.util.List;

@RestController
@RequestMapping("pedidos")
public class PedidoController {

    @Autowired
    private PedidoService service;

    // Rota para o Cliente fazer o pedido
    @PostMapping
    public ResponseEntity<Pedido> criarPedido(@RequestBody @Valid PedidoRequestDTO data) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Usuario cliente = (Usuario) authentication.getPrincipal();

        Pedido novoPedido = service.criarPedido(data, cliente);
        
        return ResponseEntity.ok(novoPedido);
    }

    // Rota para o Cliente acompanhar o status do pedido dele
    @GetMapping("/{id}")
    public ResponseEntity<PedidoResponseDTO> buscarPedido(@PathVariable Long id) {
        PedidoResponseDTO pedidoResponse = service.buscarPedidoParaRastreio(id);
        return ResponseEntity.ok(pedidoResponse);
    }

    // Rota para o DONO alterar o status (Confirmar, Cancelar, etc)
    @PatchMapping("/{id}/status")
    public ResponseEntity<Pedido> atualizarStatus(@PathVariable Long id, @RequestBody @Valid UpdateStatusDTO data) {
        Pedido pedidoAtualizado = service.atualizarStatus(id, data);
        return ResponseEntity.ok(pedidoAtualizado);
    }

    // --- Novos Endpoints para Listagem de Pedidos ---

    // Lista pedidos ativos para o cliente logado
    @GetMapping("/meus-pedidos/ativos")
    public ResponseEntity<List<Pedido>> listarMeusPedidosAtivos() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Usuario cliente = (Usuario) authentication.getPrincipal();
        List<Pedido> pedidos = service.listarPedidosAtivosParaCliente(cliente.getId());
        return ResponseEntity.ok(pedidos);
    }

    // Lista todos os pedidos para o cliente logado (incluindo finalizados)
    @GetMapping("/meus-pedidos/todos")
    public ResponseEntity<List<Pedido>> listarTodosMeusPedidos() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Usuario cliente = (Usuario) authentication.getPrincipal();
        List<Pedido> pedidos = service.listarTodosPedidosParaCliente(cliente.getId());
        return ResponseEntity.ok(pedidos);
    }

    // Lista pedidos ativos para um restaurante específico (para o dono do restaurante)
    @GetMapping("/restaurante/{restauranteId}/ativos")
    public ResponseEntity<List<Pedido>> listarPedidosAtivosPorRestaurante(@PathVariable Long restauranteId) {
        // Adicione aqui a verificação de segurança para garantir que apenas o dono do restaurante
        // ou um ADMIN possa ver esses pedidos.
        // Ex: .hasRole("ADMIN") ou uma lógica mais complexa para verificar o dono.
        List<Pedido> pedidos = service.listarPedidosAtivosParaRestaurante(restauranteId);
        return ResponseEntity.ok(pedidos);
    }

    // Lista todos os pedidos para um restaurante específico (para o dono do restaurante)
    @GetMapping("/restaurante/{restauranteId}/todos")
    public ResponseEntity<List<Pedido>> listarTodosPedidosPorRestaurante(@PathVariable Long restauranteId) {
        // Adicione aqui a verificação de segurança para garantir que apenas o dono do restaurante
        // ou um ADMIN possa ver esses pedidos.
        List<Pedido> pedidos = service.listarTodosPedidosParaRestaurante(restauranteId);
        return ResponseEntity.ok(pedidos);
    }
}
