package com.cardapiu.demo.controllers;
import com.cardapiu.demo.models.Produto;
import com.cardapiu.demo.models.Restaurante;
import com.cardapiu.demo.repositories.RestauranteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/restaurante")
public class RestauranteController {

    @Autowired
    private RestauranteRepository repository;

    @GetMapping
    public List<Restaurante> listarTodos() {
        return repository.findAll();
    }
    @PostMapping
    public Restaurante salvar(@RequestBody Restaurante restaurante) {
        return repository.save(restaurante);
    }
    @DeleteMapping("/{id}")
    public void remover(@PathVariable Long id) {
        repository.deleteById(id);
    }
    @PutMapping("/{id}")
    public Restaurante atualizar(@PathVariable Long id, @RequestBody Restaurante restauranteAtualizado) {

        return repository.findById(id).map(restaurante -> {
            restaurante.setNome(restauranteAtualizado.getNome());
            restaurante.setEmail(restauranteAtualizado.getEmail());
            restaurante.setCnjp(restauranteAtualizado.getCnjp());
            restaurante.setTelefone(restauranteAtualizado.getTelefone());
            restaurante.setUrlImage(restauranteAtualizado.getUrlImage());
            restaurante.setDescricao(restauranteAtualizado.getDescricao());

            return repository.save(restaurante);
        }).orElseThrow(() -> new RuntimeException("Produto não encontrado "));
    }
}
