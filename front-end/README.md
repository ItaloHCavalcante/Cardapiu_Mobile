# Cardapiu Mobile

Front-end Flutter Android para clientes, entregadores e painel simples do Cardapiu.

## O que esta pronto

- Login/cadastro com JWT usando `POST /auth/login` e `POST /auth/register`.
- Redirecionamento por perfil: Cliente, Admin e Entregador.
- Cardapio via `GET /produtos`, carrinho e criacao de pedido via `POST /pedidos`.
- Total calculado no app apenas para exibicao; a API recebe itens, quantidades, restaurante, observacao e `tipoEntrega`.
- Consulta de pedido via `GET /pedidos/{id}`.
- Lista de pedidos ativos do cliente via `GET /pedidos/meus-pedidos/ativos`.
- Rastreio do cliente pelo `entregaId` retornado pelo back.
- Publicacao do GPS do entregador no Firebase Realtime Database.
- Atualizacao de status via `PATCH /pedidos/{id}/status`.
- Permissoes Android para localizacao em primeiro e segundo plano.

## Configuracao

O app usa `dart-define`, entao nao precisa commitar `google-services.json`.

```powershell
flutter run `
  --dart-define=API_BASE_URL=http://10.0.2.2:8080 `
  --dart-define=DEFAULT_RESTAURANT_ID=1 `
  --dart-define=FIREBASE_API_KEY=SUACHAVE `
  --dart-define=FIREBASE_APP_ID=SEUAPPID `
  --dart-define=FIREBASE_PROJECT_ID=SEUPROJETO `
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=SEUSENDERID `
  --dart-define=FIREBASE_DATABASE_URL=https://SEUPROJETO-default-rtdb.firebaseio.com `
  --dart-define=FIREBASE_DELIVERY_PATH=entregas
```

No emulador Android, `10.0.2.2` aponta para o `localhost` da maquina.

## Estrutura Firebase

O entregador publica a localizacao em:

```text
entregas/{entregaId}/localizacaoAtual
```

Payload:

```json
{
  "latitude": -23.0,
  "longitude": -46.0,
  "accuracy": 8.4,
  "speed": 2.1,
  "heading": 90.0,
  "delivererId": "motoboy@email.com",
  "status": "SAIU_PARA_ENTREGA",
  "updatedAt": "2026-06-09T07:00:00.000Z"
}
```

Se o back usar outro caminho, altere apenas `FIREBASE_DELIVERY_PATH`.

## Contrato de pedido

O front envia `tipoEntrega` conforme o modo escolhido no carrinho:

- `ENTREGA` para delivery.
- `RETIRADA_NO_LOCAL` para retirada/balcao/mesa.
