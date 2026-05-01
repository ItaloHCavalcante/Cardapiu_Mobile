package com.cardapiu.demo.controllers;

import com.cardapiu.demo.dtos.EntregadorRequestDTO;
import com.cardapiu.demo.dtos.EntregadorResponseDTO;
import com.cardapiu.demo.services.EntregadorService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("entregadores")
public class EntregadorController {

    @Autowired
    private EntregadorService service;

    @PostMapping
    public ResponseEntity<EntregadorResponseDTO> cadastrar(@RequestBody @Valid EntregadorRequestDTO data){
        EntregadorResponseDTO response = service.cadastrarEntregador(data);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/disponiveis")
    public ResponseEntity<List<EntregadorResponseDTO>> listarDisponiveis() {
        return ResponseEntity.ok(service.listarDisponiveis());

    }

}
