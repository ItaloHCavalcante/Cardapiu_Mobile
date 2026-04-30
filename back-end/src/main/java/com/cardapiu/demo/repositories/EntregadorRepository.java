package com.cardapiu.demo.repositories;

import com.cardapiu.demo.models.Entregador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EntregadorRepository extends JpaRepository<Entregador, Long> {

    // Para listar apenas os entregadores disponiveis
    List<Entregador> findAllByDisponivelTrue();

}
