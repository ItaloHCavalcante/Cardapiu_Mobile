package com.cardapiu.demo.dtos;

import com.cardapiu.demo.models.StatusPedido;

public record UpdateStatusDTO(
        StatusPedido status
) {}