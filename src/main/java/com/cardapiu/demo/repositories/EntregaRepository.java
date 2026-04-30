package com.cardapiu.demo.repositories;

import com.cardapiu.demo.models.Entrega;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface EntregaRepository extends JpaRepository<Entrega, Long> {
    //O entregador encontra a entrega ativa pelo id do pedido
    Optional<Entrega> findByPedidoId(Long pedidoId);
}
