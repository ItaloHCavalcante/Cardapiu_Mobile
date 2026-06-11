enum OrderStatus {
  pendente,
  confirmado,
  emPreparo,
  aguardandoEntregador,
  aguardandoColeta,
  saiuParaEntrega,
  emTransito,
  entregue,
  cancelado,
  finalizado,
  unknown;

  String get apiValue => switch (this) {
    OrderStatus.pendente => 'PENDENTE',
    OrderStatus.confirmado => 'CONFIRMADO',
    OrderStatus.emPreparo => 'EM_PREPARO',
    OrderStatus.aguardandoEntregador => 'AGUARDANDO_ENTREGADOR',
    OrderStatus.aguardandoColeta => 'AGUARDANDO_COLETA',
    OrderStatus.saiuParaEntrega => 'SAIU_PARA_ENTREGA',
    OrderStatus.emTransito => 'EM_TRANSITO',
    OrderStatus.entregue => 'ENTREGUE',
    OrderStatus.cancelado => 'CANCELADO',
    OrderStatus.finalizado => 'FINALIZADO',
    OrderStatus.unknown => 'DESCONHECIDO',
  };

  String get label => switch (this) {
    OrderStatus.pendente => 'Pendente',
    OrderStatus.confirmado => 'Confirmado',
    OrderStatus.emPreparo => 'Em preparo',
    OrderStatus.aguardandoEntregador => 'Aguardando entregador',
    OrderStatus.aguardandoColeta => 'Motoboy a caminho do restaurante',
    OrderStatus.saiuParaEntrega => 'Saiu para entrega',
    OrderStatus.emTransito => 'Pedido a caminho',
    OrderStatus.entregue => 'Entregue',
    OrderStatus.cancelado => 'Cancelado',
    OrderStatus.finalizado => 'Finalizado',
    OrderStatus.unknown => 'Desconhecido',
  };

  String get customerMessage => switch (this) {
    OrderStatus.pendente => 'Pedido recebido e aguardando confirmacao.',
    OrderStatus.confirmado => 'Pedido confirmado pelo restaurante.',
    OrderStatus.emPreparo => 'Seu pedido esta sendo preparado.',
    OrderStatus.aguardandoEntregador =>
      'Restaurante procurando um entregador disponivel.',
    OrderStatus.aguardandoColeta =>
      'O motoboy aceitou seu pedido e esta indo buscar.',
    OrderStatus.saiuParaEntrega ||
    OrderStatus.emTransito => 'Pedido a caminho.',
    OrderStatus.entregue ||
    OrderStatus.finalizado => 'Pedido entregue. Bom apetite!',
    OrderStatus.cancelado => 'Pedido cancelado.',
    OrderStatus.unknown => 'Acompanhando atualizacoes do pedido.',
  };

  bool get canShowTracking => switch (this) {
    OrderStatus.aguardandoColeta ||
    OrderStatus.saiuParaEntrega ||
    OrderStatus.emTransito ||
    OrderStatus.entregue ||
    OrderStatus.finalizado => true,
    _ => false,
  };

  static OrderStatus fromApi(String? value) {
    final normalized = value?.toUpperCase().trim();
    return switch (normalized) {
      'PENDENTE' => OrderStatus.pendente,
      'CONFIRMADO' => OrderStatus.confirmado,
      'EM_PREPARO' => OrderStatus.emPreparo,
      'AGUARDANDO_ENTREGADOR' => OrderStatus.aguardandoEntregador,
      'AGUARDANDO_COLETA' => OrderStatus.aguardandoColeta,
      'SAIU_PARA_ENTREGA' => OrderStatus.saiuParaEntrega,
      'EM_TRANSITO' => OrderStatus.emTransito,
      'ENTREGUE' => OrderStatus.entregue,
      'CANCELADO' => OrderStatus.cancelado,
      'FINALIZADO' => OrderStatus.finalizado,
      _ => OrderStatus.unknown,
    };
  }
}

const backendPatchStatuses = [
  OrderStatus.pendente,
  OrderStatus.confirmado,
  OrderStatus.emPreparo,
  OrderStatus.aguardandoEntregador,
  OrderStatus.saiuParaEntrega,
  OrderStatus.entregue,
  OrderStatus.cancelado,
];
