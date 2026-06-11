package com.cardapiu.demo.models;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "pedidos")
@Data
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    // Relacionamento com o cliente que fez o pedido
    @ManyToOne
    @JoinColumn(name = "cliente_id")
    private Usuario cliente;

    // Adicionado: Relacionamento com o restaurante
    @ManyToOne
    @JoinColumn(name = "restaurante_id")
    private Restaurante restaurante;

    @Column(nullable = false)
    private LocalDateTime dataCriacao = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatusPedido status = StatusPedido.PENDENTE;

    // Adicionado: Campo para diferenciar entrega ou retirada no local
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoEntrega tipoEntrega = TipoEntrega.ENTREGA; // Valor padrão

    // RELACIONAMENTO COM OS ITENS DO PEDIDO
    @OneToMany(mappedBy = "pedido", cascade = CascadeType.ALL)
    private List<ItemPedido> itens;

    private Double valorTotal;

    private String observacao;
}