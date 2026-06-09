package com.cardapiu.demo.services;

import com.cardapiu.demo.dtos.ProdutoRequestDTO;
import com.cardapiu.demo.models.Categoria;
import com.cardapiu.demo.models.Produto;
import com.cardapiu.demo.models.Restaurante;
import com.cardapiu.demo.repositories.CategoriaRepository;
import com.cardapiu.demo.repositories.ProdutoRepository;
import com.cardapiu.demo.repositories.RestauranteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProdutoService {

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private RestauranteRepository restauranteRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    public List<Produto> listarTodos() {
        return produtoRepository.findAll();
    }

    public Produto criarProduto(ProdutoRequestDTO data) {
        Restaurante restaurante = restauranteRepository.findById(data.restauranteId())
                .orElseThrow(() -> new RuntimeException("Restaurante não encontrado com ID: " + data.restauranteId()));

        Categoria categoria = null;
        if (data.categoriaId() != null) {
            categoria = categoriaRepository.findById(data.categoriaId())
                    .orElseThrow(() -> new RuntimeException("Categoria não encontrada com ID: " + data.categoriaId()));
        }

        Produto novoProduto = new Produto();
        novoProduto.setNome(data.nome());
        novoProduto.setDescricao(data.descricao());
        novoProduto.setPreco(data.preco());
        novoProduto.setUrlImage(data.urlImage());
        novoProduto.setRestaurante(restaurante);
        novoProduto.setCategoria(categoria);

        return produtoRepository.save(novoProduto);
    }

    public void remover(Long id) {
        produtoRepository.deleteById(id);
    }

    public Produto atualizar(Long id, ProdutoRequestDTO data) {
        return produtoRepository.findById(id).map(produto -> {
            Restaurante restaurante = restauranteRepository.findById(data.restauranteId())
                    .orElseThrow(() -> new RuntimeException("Restaurante não encontrado com ID: " + data.restauranteId()));

            Categoria categoria = null;
            if (data.categoriaId() != null) {
                categoria = categoriaRepository.findById(data.categoriaId())
                        .orElseThrow(() -> new RuntimeException("Categoria não encontrada com ID: " + data.categoriaId()));
            }

            produto.setNome(data.nome());
            produto.setPreco(data.preco());
            produto.setDescricao(data.descricao());
            produto.setUrlImage(data.urlImage());
            produto.setRestaurante(restaurante);
            produto.setCategoria(categoria);

            return produtoRepository.save(produto);
        }).orElseThrow(() -> new RuntimeException("Produto não encontrado com ID: " + id));
    }
}
