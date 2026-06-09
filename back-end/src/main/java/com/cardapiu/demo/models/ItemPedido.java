package com.cardapiu.demo.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties; // Importando a anotação
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "itens_pedido")
@Data
@JsonIgnoreProperties({"pedido"}) // Adicionado: Ignora a propriedade 'pedido' ao serializar ItemPedido
public class ItemPedido {

    @Id
    @GeneratedValue( strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "produto_id")
    private Produto produto;

    @ManyToOne
    @JoinColumn(name = "pedido_id")
    private Pedido pedido;

    private Integer quantidade;
    private Double precoUnitario; //Aqui guarda o preço no momento da compra
    private Double precoTotal; // Valor total para este item (quantidade * precoUnitario)

}