package com.cardapiu.demo.models;


import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "entrega")
@Data
public class Entrega {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "pedido_id")
    private Pedido pedido;

    @ManyToOne
    @JoinColumn(name = "entregador_id")
    private Entregador entregador;
    private LocalDateTime horarioSaida;
    private LocalDateTime horarioChegada;

    private String LinkMapaRota;
}
