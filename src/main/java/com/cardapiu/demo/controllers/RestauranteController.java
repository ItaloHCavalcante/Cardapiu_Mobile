package com.cardapiu.demo.controllers;
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
}
