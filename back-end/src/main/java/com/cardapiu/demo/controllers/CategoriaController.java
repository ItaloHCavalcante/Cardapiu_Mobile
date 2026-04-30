package com.cardapiu.demo.controllers;

import com.cardapiu.demo.models.Categoria;
import com.cardapiu.demo.repositories.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/categorias")
public class CategoriaController {

    @Autowired
    private CategoriaRepository repository;

    @GetMapping
    private List<Categoria> listarTodas(){
        return repository.findAll();

    }
    @PostMapping
    public Categoria salvar(@RequestBody Categoria categoria){
        return repository.save(categoria);
    }
    @DeleteMapping("/{id}")
    public void remover(@PathVariable Long id) {
        repository.deleteById(id);
    }
}

