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
    public void remover(@PathVariable Produto produto) {
        repository.deleteById(produto.getId());
    }
}
