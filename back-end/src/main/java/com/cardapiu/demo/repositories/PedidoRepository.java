package com.cardapiu.demo.repositories;

import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.models.StatusPedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {
    // Filtra pedidos por Status
    List<Pedido> findAllByStatus(StatusPedido status);

    // Busca todos os pedidos de um cliente específico
    List<Pedido> findAllByClienteId(Long clienteId);

    // Busca todos os pedidos de um restaurante específico
    List<Pedido> findAllByRestauranteId(Long restauranteId);

    // Busca pedidos de um cliente específico com um determinado status
    List<Pedido> findAllByClienteIdAndStatus(Long clienteId, StatusPedido status);

    // Busca pedidos de um restaurante específico com um determinado status
    List<Pedido> findAllByRestauranteIdAndStatus(Long restauranteId, StatusPedido status);

    // Busca pedidos de um restaurante específico com status diferente de uma lista de status
    List<Pedido> findAllByRestauranteIdAndStatusNotIn(Long restauranteId, List<StatusPedido> statusExcluidos);

    // Busca pedidos de um cliente específico com status diferente de uma lista de status
    List<Pedido> findAllByClienteIdAndStatusNotIn(Long clienteId, List<StatusPedido> statusExcluidos);
}