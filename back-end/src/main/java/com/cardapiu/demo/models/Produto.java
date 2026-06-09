package com.cardapiu.demo.models;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// import java.awt.*; // REMOVIDO: Esta importação não é necessária e pode causar conflitos

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data // Adicionado para gerar getters e setters automaticamente
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String descricao;
    private Double preco;
    private String urlImage;

    @ManyToOne
    @JoinColumn(name = "categoria_id", nullable = true)
    @JsonIgnoreProperties("Produtos") // Evita um loop infinito quando o Spring gerar o JSON
    private Categoria categoria;

    // Adicionado: Relacionamento com o Restaurante
    @ManyToOne
    @JoinColumn(name = "restaurante_id", nullable = true) // Alterado para 'true' temporariamente para depuração
    private Restaurante restaurante;

    // Removidos getters e setters manuais, pois @Data do Lombok já faz isso
}