package com.cardapiu.demo.services;

import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.Pedido;
import com.cardapiu.demo.models.StatusPedido;
import com.cardapiu.demo.repositories.PedidoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class PedidoService {

    @Autowired
    private PedidoRepository repository;

    //Metodo para o dono atualizar o status
    public Pedido atualizarStatus(Long id, UpdateStatusDTO data) {
        Optional<Pedido> pedidoOptional = repository.findById(id);

        if (pedidoOptional.isPresent()) {
            Pedido pedido = pedidoOptional.get();

            //Se o status atual for cancelado, não pode mudar para em preparo

            pedido.setStatus(data.status());
            return repository.save(pedido);
        }

        throw new RuntimeException("Pedido não encontrado");
    }

    public Pedido buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));
    }
}