package com.cardapiu.demo.models;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "entregador")
@Data
public class Entregador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    //Vincula o entregador ao usuário para ele ter login e senha
    @OneToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    private String placaVeiculo;
    private String telefone;

    //Para rota em tempo real
    private Double latitudeAtual;
    private Double longitudeAtual;

    private Boolean disponivel = true;
}
