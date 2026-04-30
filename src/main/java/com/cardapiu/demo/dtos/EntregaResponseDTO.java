package com.cardapiu.demo.dtos;

import java.time.LocalDateTime;

public record EntregaResponseDTO(
        Long id,
        Long pedidoId,
        EntregadorResponseDTO entregador,
        LocalDateTime horarioSaida,
        LocalDateTime horarioChegada,
        String linkMapaRota
) {}
