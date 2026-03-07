package com.cardapiu.demo.controllers;
import com.cardapiu.demo.models.Produto;
import com.cardapiu.demo.repositories.ProdutoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    @Autowired
    private ProdutoRepository repository;

    @GetMapping
    public List<Produto> listarTodos() {
        return repository.findAll();
    }
    @PostMapping
    public Produto salvar(@RequestBody Produto produto) {
        return repository.save(produto);
    }
    @DeleteMapping("/{id}")
    public void remover(@PathVariable Long id) {
        repository.deleteById(id);
    }
    @PutMapping("/{id}")
    public Produto atualizar(@PathVariable Long id, @RequestBody Produto produtoAtualizado) {
        // 2. Buscamos o produto original no banco
        return repository.findById(id).map(produto -> {
            // 3. Atualizamos apenas os campos necessários
            produto.setNome(produtoAtualizado.getNome());
            produto.setPreco(produtoAtualizado.getPreco());
            produto.setDescricao(produtoAtualizado.getDescricao());

            // 4. Salvamos a versão atualizada
            return repository.save(produto);
        }).orElseThrow(() -> new RuntimeException("Produto não encontrado "));
    }

}

