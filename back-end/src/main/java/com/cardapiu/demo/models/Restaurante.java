package com.cardapiu.demo.models;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data; // Importando a anotação Data do Lombok
import lombok.NoArgsConstructor;

// import java.awt.*; // REMOVIDO: Esta importação não é necessária

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data // Adicionado: Gera automaticamente getters, setters, equals, hashCode e toString
public class Restaurante {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String email;
    private String cnjp;
    private String endereco;
    private String telefone;
    private String descricao;
    private String urlImage;

    // Removidos os getters e setters manuais, pois @Data do Lombok já os gera
}