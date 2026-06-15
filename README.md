# Cardapiu Mobile

O **Cardapiu Mobile** é uma solução completa de delivery e menu digital projetada para aproximar clientes, restaurantes e entregadores de forma ágil e eficiente. Composto por um ecossistema robusto que integra um aplicativo móvel multiplataforma e uma API de alto desempenho, o sistema foi estruturado seguindo rigorosas práticas de engenharia de software, garantindo escalabilidade, segurança e modularidade.

---

## 🗺️ 1. Arquitetura do Ecossistema

O projeto adota o modelo de arquitetura **Cliente-Servidor distribuído**, com rígida separação de responsabilidades:

* **Back-End (API RESTful):** Desenvolvido em **Java com Spring Boot 3.x**. Atua como o núcleo de inteligência do negócio, gerenciando persistência, regras de negócio complexas, segurança, autenticação baseada em perfis e notificações via infraestrutura de mensageria.
* **Front-End (Mobile App):** Desenvolvido em **Flutter (Dart)**. Utiliza uma base de código única para entregar uma experiência fluida e nativa tanto no ecossistema Android quanto iOS.

---

## 🚀 2. Funcionalidades Principais

| 🛒 Para Clientes | 🛵 Para Entregadores |
| :--- | :--- |
| • Navegação fluida por catálogo de restaurantes e categorias. | • Visualização e aceitação de ordens de entrega disponíveis. |
| • Detalhes de produtos com adição simplificada ao carrinho. | • Atualização em tempo real do status de transporte. |
| • Acompanhamento e histórico de pedidos efetuados. | • Compartilhamento de geolocalização contínua para rastreamento. |
| • Interface intuitiva e focada em experiência do usuário. | • Painel simples para gerenciamento da jornada de trabalho. |

---

## 🛠️ 3. Tecnologias Utilizadas

### **Back-End**
* **Java 17** como linguagem base.
* **Spring Boot 3.x** para fundação do ecossistema de microserviços/API.
* **Spring Security & JWT (JSON Web Tokens)** para autenticação stateless e controle de permissões.
* **Spring Data JPA** para mapeamento objeto-relacional e abstração de banco de dados.
* **Firebase Admin SDK** para orquestração de notificações push em tempo real.

### **Front-End**
* **Flutter & Dart** para construção de componentes visuais de alto desempenho.
* **Riverpod / Provider** para gerenciamento de estado previsível e reativo.
* **Dio / HTTP** como clientes robustos de rede com suporte a interceptadores.

---

## 📂 4. Estrutura de Diretórios do Projeto

```text
cardapiu_mobile/
├── back-end/                  # Módulo do Servidor (Spring Boot)
│   ├── src/main/java/com/cardapiu/demo/
│   │   ├── controllers/       # Exposição dos endpoints REST da API
│   │   ├── dtos/              # Objetos de Transferência de Dados (Requests/Responses)
│   │   ├── exceptions/        # Manipulação e interceptação global de erros
│   │   ├── infra/             # Configurações de segurança (JWT), filtros e Firebase
│   │   ├── models/            # Entidades do domínio (Pedido, Usuário, Produto, Restaurante)
│   │   ├── repositories/      # Camada de comunicação direta com o Banco de Dados
│   │   └── services/          # Centralização de toda a lógica de negócio
│   └── pom.xml                # Gerenciador de dependências Maven
│
├── front-end/                 # Módulo do Aplicativo Móvel (Flutter)
│   ├── lib/
│   │   ├── aplicativo/        # Inicialização estrutural e injetores de estado (Providers)
│   │   ├── compartilhado/     # Componentes de interface (Widgets) reaproveitáveis
│   │   ├── funcionalidades/    # Módulos encapsulados (Autenticação, Pedidos, Rastreamento)
│   │   └── nucleo/            # Clientes de rede, interceptadores, temas e utilitários
│   └── pubspec.yaml           # Gerenciador de pacotes e dependências do Flutter
