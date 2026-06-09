package com.cardapiu.demo.controllers;
import com.cardapiu.demo.dtos.ProdutoRequestDTO;
import com.cardapiu.demo.models.Produto;
import com.cardapiu.demo.services.ProdutoService; // Vamos criar este serviço
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    @Autowired
    private ProdutoService service; // Injetando o novo serviço

    @GetMapping
    public List<Produto> listarTodos() {
        return service.listarTodos();
    }

    @PostMapping
    public ResponseEntity<Produto> criarProduto(@RequestBody @Valid ProdutoRequestDTO data) {
        Produto novoProduto = service.criarProduto(data);
        return ResponseEntity.ok(novoProduto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> remover(@PathVariable Long id) {
        service.remover(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Produto> atualizar(@PathVariable Long id, @RequestBody @Valid ProdutoRequestDTO data) {
        Produto produtoAtualizado = service.atualizar(id, data);
        return ResponseEntity.ok(produtoAtualizado);
    }
}