package com.cardapiu.demo.models;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Data
public class Categoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    // O 'mappedBy' diz que o mapeamento real está lá na classe Produto
    @OneToMany(mappedBy = "categoria")
    private List<Produto> produtos;
}
