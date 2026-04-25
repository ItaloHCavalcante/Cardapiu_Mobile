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
}