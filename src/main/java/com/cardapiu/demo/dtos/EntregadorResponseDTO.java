package com.cardapiu.demo.dtos;

import com.cardapiu.demo.models.StatusPedido;
import java.time.LocalDateTime;
import java.util.List;

public record EntregadorResponseDTO(
        Long id,
        String nome,
        String telefone,
        String placaVeiculo,
        Double latitudeAtual,
        Double longitudeAtual,
        Boolean disponivel
) {}