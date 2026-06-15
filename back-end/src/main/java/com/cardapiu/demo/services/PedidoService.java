package com.cardapiu.demo.services;

import com.cardapiu.demo.dtos.ItemPedidoRequestDTO;
import com.cardapiu.demo.dtos.PedidoRequestDTO;
import com.cardapiu.demo.dtos.PedidoResponseDTO;
import com.cardapiu.demo.dtos.UpdateStatusDTO;
import com.cardapiu.demo.models.*;
import com.cardapiu.demo.repositories.EntregaRepository;
import com.cardapiu.demo.repositories.ItemPedidoRepository;
import com.cardapiu.demo.repositories.PedidoRepository;
import com.cardapiu.demo.repositories.ProdutoRepository;
import com.cardapiu.demo.repositories.RestauranteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;

    @Autowired
    private EntregaRepository entregaRepository;

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private ItemPedidoRepository itemPedidoRepository;

    @Autowired
    private RestauranteRepository restauranteRepository;

    @Autowired
    private NotificationService notificationService;

    @Transactional
    public Pedido criarPedido(PedidoRequestDTO pedidoRequestDTO, Usuario cliente) {
        Restaurante restaurante = restauranteRepository.findById(pedidoRequestDTO.restauranteId())
                .orElseThrow(() -> new RuntimeException("Restaurante não encontrado: " + pedidoRequestDTO.restauranteId()));

        Pedido pedido = new Pedido();
        pedido.setCliente(cliente);
        pedido.setRestaurante(restaurante);
        pedido.setStatus(StatusPedido.PENDENTE);
        pedido.setObservacao(pedidoRequestDTO.observacao());
        pedido.setValorTotal(0.0);
        pedido.setTipoEntrega(pedidoRequestDTO.tipoEntrega()); // Define o tipo de entrega

        Pedido pedidoSalvo = pedidoRepository.save(pedido);

        List<ItemPedido> itensPedido = new ArrayList<>();
        double valorTotalCalculado = 0.0;

        for (ItemPedidoRequestDTO itemDTO : pedidoRequestDTO.itens()) {
            Produto produto = produtoRepository.findById(itemDTO.produtoId())
                    .orElseThrow(() -> new RuntimeException("Produto não encontrado: " + itemDTO.produtoId()));

            if (!produto.getRestaurante().getId().equals(restaurante.getId())) {
                throw new RuntimeException("Produto com ID " + itemDTO.produtoId() + " não pertence ao restaurante com ID " + restaurante.getId());
            }

            ItemPedido itemPedido = new ItemPedido();
            itemPedido.setPedido(pedidoSalvo);
            itemPedido.setProduto(produto);
            itemPedido.setQuantidade(itemDTO.quantidade());
            itemPedido.setPrecoUnitario(produto.getPreco());
            
            double precoTotalItem = produto.getPreco() * itemDTO.quantidade();
            itemPedido.setPrecoTotal(precoTotalItem); 

            itensPedido.add(itemPedido);
            valorTotalCalculado += precoTotalItem;
        }

        itemPedidoRepository.saveAll(itensPedido);

        pedidoSalvo.setValorTotal(valorTotalCalculado);
        pedidoSalvo.setItens(itensPedido);

        return pedidoRepository.save(pedidoSalvo);
    }

    public Pedido atualizarStatus(Long id, UpdateStatusDTO data) {
        Pedido pedido = pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        pedido.setStatus(data.status());
        Pedido pedidoAtualizado = pedidoRepository.save(pedido);

        enviarNotificacaoDeStatus(pedidoAtualizado);

        return pedidoAtualizado;
    }

    private void enviarNotificacaoDeStatus(Pedido pedido) {
        Usuario cliente = pedido.getCliente();
        if (cliente == null || cliente.getFcmToken() == null) {
            return;
        }

        String fcmToken = cliente.getFcmToken();
        String titulo = "Atualização do seu Pedido!";
        String corpo = "";

        if (pedido.getStatus() == StatusPedido.SAIU_PARA_ENTREGA) {
            corpo = "Seu pedido saiu para entrega!";
        } else if (pedido.getStatus() == StatusPedido.ENTREGUE) {
            corpo = "Seu pedido foi entregue! Bom apetite!";
        }

        if (!corpo.isEmpty()) {
            notificationService.enviarNotificacao(fcmToken, titulo, corpo);
        }
    }

    public Pedido buscarPorId(Long id) {
        return pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));
    }

    @Transactional(readOnly = true)
    public PedidoResponseDTO buscarPedidoParaRastreio(Long pedidoId) {
        Pedido pedido = pedidoRepository.findById(pedidoId)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        Optional<Entrega> entregaOptional = entregaRepository.findByPedidoId(pedidoId);
        Long entregaId = entregaOptional.map(Entrega::getId).orElse(null);

        return new PedidoResponseDTO(pedido, entregaId);
    }

    // --- Novos métodos para listagem de pedidos ---

    // Lista pedidos ativos para um cliente (exclui CANCELADO e ENTREGUE)
    public List<Pedido> listarPedidosAtivosParaCliente(Long clienteId) {
        List<StatusPedido> statusExcluidos = Arrays.asList(StatusPedido.CANCELADO, StatusPedido.ENTREGUE);
        return pedidoRepository.findAllByClienteIdAndStatusNotIn(clienteId, statusExcluidos);
    }

    // Lista pedidos ativos para um restaurante (exclui CANCELADO e ENTREGUE)
    public List<Pedido> listarPedidosAtivosParaRestaurante(Long restauranteId) {
        List<StatusPedido> statusExcluidos = Arrays.asList(StatusPedido.CANCELADO, StatusPedido.ENTREGUE);
        return pedidoRepository.findAllByRestauranteIdAndStatusNotIn(restauranteId, statusExcluidos);
    }

    // Lista todos os pedidos de um cliente (incluindo finalizados)
    public List<Pedido> listarTodosPedidosParaCliente(Long clienteId) {
        return pedidoRepository.findAllByClienteId(clienteId);
    }

    // Lista todos os pedidos de um restaurante (incluindo finalizados)
    public List<Pedido> listarTodosPedidosParaRestaurante(Long restauranteId) {
        return pedidoRepository.findAllByRestauranteId(restauranteId);
    }
}
