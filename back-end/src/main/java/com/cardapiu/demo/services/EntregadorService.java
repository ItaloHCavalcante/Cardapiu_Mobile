package com.cardapiu.demo.services;

import com.cardapiu.demo.dtos.EntregadorRequestDTO;
import com.cardapiu.demo.dtos.EntregadorResponseDTO;
import com.cardapiu.demo.models.Entregador;
import com.cardapiu.demo.models.Usuario;
import com.cardapiu.demo.repositories.EntregadorRepository;
import com.cardapiu.demo.repositories.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EntregadorService {

    @Autowired
    private EntregadorRepository repository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    public EntregadorResponseDTO cadastrarEntregador(EntregadorRequestDTO data) {
        Usuario usuario = usuarioRepository.findById(data.usuarioId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        Entregador novoEntregador = new Entregador();
        novoEntregador.setUsuario(usuario);
        novoEntregador.setPlacaVeiculo(data.placaVeiculo());
        novoEntregador.setTelefone(data.telefone());
        novoEntregador.setDisponivel(true);  // Já entra pronto para realizar entregas

        repository.save(novoEntregador);
        return mapToResponse(novoEntregador);
    }
    //Para o dono ver os entregadores disponíveis
    public List<EntregadorResponseDTO> listarDisponiveis(){
        return repository.findAllByDisponivelTrue()
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }
    // Converter o model em DTO
    private EntregadorResponseDTO mapToResponse(Entregador entregador) {
        return new EntregadorResponseDTO(
                entregador.getId(),
                entregador.getUsuario().getLogin(),
                entregador.getPlacaVeiculo(),
                entregador.getTelefone(),
                entregador.getLatitudeAtual(),
                entregador.getLongitudeAtual(),
                entregador.getDisponivel()
        );
    }

}
