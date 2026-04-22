#  Ruby Orchestrator

<div align="center">
  <img src="https://skillicons.dev/icons?i=ruby,docker,postgres,linux,github,vscode,debian" />
</div>

---
##  A Visão / The Vision

### (PT-BR) O Fim do Script Frágil
A maioria das automações começa como um script simples e linear. No entanto, à medida que a complexidade cresce, esses scripts se tornam "Castelos de Cartas": se uma chamada de API falha ou um banco de dados oscila, o processo morre pela metade, deixando dados corrompidos e sem logs de rastreabilidade.

O **Ruby Orchestrator** propõe uma mudança de paradigma: **Saímos da execução linear para a execução governada.**



Nesta visão, o "Maestro" não executa as notas; ele governa o tempo e a resiliência. 
- **Desacoplamento Temporal:** As tarefas não precisam saber quem veio antes ou quem vem depois. Elas apenas cumprem seu contrato com o Contexto.
- **Governança de Erros:** O Orchestrator transforma erros fatais em eventos tratáveis. Se um "músico" falha, o maestro decide se deve repetir o compasso (Retry) ou encerrar a sinfonia graciosamente (Circuit Break).
- **Transparência Operacional:** Ao final de cada execução, você não tem apenas um "ok" ou "erro", você tem um relatório completo do estado do Contexto em cada etapa do pipeline.

### (EN-US) The End of the Fragile Script
Most automations begin as simple, linear scripts. However, as complexity grows, these scripts turn into "House of Cards": if an API call fails or a database flickers, the process dies halfway through, leaving behind corrupted data and no traceability logs.

**Ruby Orchestrator** proposes a paradigm shift: **Moving from linear execution to governed execution.**

In this vision, the "Conductor" doesn't play the notes; it governs timing and resilience.
- **Temporal Decoupling:** Tasks don't need to know who came before or who follows. They simply fulfill their contract with the Context.
- **Error Governance:** The Orchestrator transforms fatal errors into manageable events. If a "musician" fails, the conductor decides whether to repeat the measure (Retry) or end the symphony gracefully (Circuit Break).
- **Operational Transparency:** At the end of every execution, you don't just get an "ok" or "error"; you get a full report of the Context's state at every stage of the pipeline.

---

##  Explicação da Arquitetura / Architecture Deep Dive

### 1. Interactors & Command Pattern (A Lógica Atômica / Atomic Logic)
**[PT-BR]**
O projeto abandona scripts gigantes em favor do **Command Pattern**. Cada classe em `lib/tasks` é um "Interactor" especializado.
- **Isolamento de Responsabilidade:** Se você precisa alterar a regra de cálculo de um imposto, altera apenas a `ProcessDataTask`. O restante do sistema permanece intacto.
- **Plug-and-Play:** Como todas as tarefas herdam de `BaseTask`, o Maestro (`Engine`) executa qualquer uma delas sem conhecer seus detalhes internos. É o polimorfismo em ação.

**[EN-US]**
The project moves away from bloated scripts in favor of the **Command Pattern**. Each class within `lib/tasks` is a specialized "Interactor."
- **Separation of Concerns:** If you need to change a tax calculation rule, you only modify `ProcessDataTask`. The rest of the system remains untouched.
- **Plug-and-Play:** Since all tasks inherit from `BaseTask`, the Conductor (`Engine`) can execute any of them without knowing their internal details. This is polymorphism in action.

### 2. State Management & The Context (A Gestão de Estado / State Management)
**[PT-BR]**
O **Context** é o "Single Source of Truth" (Fonte Única de Verdade) da execução. 
- **Desacoplamento de Dados:** As tarefas não passam argumentos entre si; elas leem e escrevem no Contexto. Isso elimina o "Spaghetti Code".
- **Rastreabilidade:** O contexto mantém um "snapshot" exato do momento do erro, facilitando o debug em produção.

**[EN-US]**
The **Context** serves as the "Single Source of Truth" for the execution.
- **Data Decoupling:** Tasks do not pass arguments to each other; they read from and write to the Context. This eliminates "Spaghetti Code."
- **Traceability:** The context maintains an exact "snapshot" of the error moment, making production debugging much easier.

### 3. Native Resilience & Backoff (Resiliência Nativa)
**[PT-BR]**
Utilizamos o `retry` nativo do Ruby acoplado a uma lógica de **Exponential Backoff**. O sistema entende que falhas de rede são transitórias e espera intervalos crescentes antes de tentar novamente, protegendo os recursos de destino.

**[EN-US]**
We leverage Ruby's native `retry` coupled with **Exponential Backoff** logic. The system understands that network failures are transient and waits for increasing intervals before retrying, protecting downstream resources.

---

##  Funcionamento do Código / How the Code Works

### 1. Ponto de Entrada / Entry Point (`main.rb`)
**[PT-BR]** O `main.rb` faz o **Bootstrap**. Ele configura o `$LOAD_PATH`, instancia o `Engine` e registra a sequência de tarefas. É o cérebro que define a estratégia de execução.
**[EN-US]** `main.rb` handles the **Bootstrap**. It configures the `$LOAD_PATH`, instantiates the `Engine`, and registers the task sequence. It is the brain that defines the execution strategy.

### 2. O Maestro / The Conductor (`lib/core/engine.rb`)
**[PT-BR]** O `Engine` percorre a lista de tarefas. Ele envolve cada execução em um bloco de resiliência. Se uma tarefa falha, o `Engine` decide se deve tentar novamente ou interromper o fluxo para preservar a integridade dos dados.
**[EN-US]** The `Engine` iterates through the task list. It wraps each execution in a resilience block. If a task fails, the `Engine` decides whether to retry or halt the flow to preserve data integrity.

### 3. Unidades de Trabalho / Work Units (`lib/tasks/`)
**[PT-BR]**
- **`FetchApiTask`**: Coleta dados externos e os injeta no `Context`.
- **`ProcessDataTask`**: Limpa e transforma os dados presentes no `Context`.
- **`SaveTask`**: Persiste o resultado final através de um conector.
**[EN-US]**
- **`FetchApiTask`**: Collects external data and injects it into the `Context`.
- **`ProcessDataTask`**: Cleans and transforms the data within the `Context`.
- **`SaveTask`**: Persists the final result through a connector.

### 4. Adaptadores de Infra / Infra Adapters (`lib/connectors/`)
**[PT-BR]** O `DatabaseConnector` isola a lógica técnica (SQL/Conexões). Se você mudar o banco de dados, altera apenas este arquivo, sem tocar na lógica de negócio das tarefas.
**[EN-US]** The `DatabaseConnector` isolates technical logic (SQL/Connections). If you change the database, you only modify this file without touching the tasks' business logic.

### 5. Orquestração Docker / Docker Orchestration
**[PT-BR]** O `Dockerfile` cria o ambiente Linux estável. O `docker-compose.yml` levanta o banco de dados e conecta o código Ruby a ele automaticamente via rede virtual.
**[EN-US]** The `Dockerfile` creates a stable Linux environment. The `docker-compose.yml` spins up the database and automatically connects the Ruby code via a virtual network.

---

##  Diferenciais Técnicos / Key Features

| Recurso / Feature | Explicação Detalhada (PT-BR) | Detailed Explanation (EN-US) |
| :--- | :--- | :--- |
| **Native Retry & Backoff** | Utiliza a capacidade nativa do Ruby para reinicializar blocos de código, aplicando algoritmos de recuo exponencial para evitar sobrecarga em serviços instáveis. | Leverages Ruby's native capability to re-run code blocks, applying exponential backoff algorithms to prevent overloading unstable services. |
| **Fluent DSL & Orchestration** | Interface fluida que permite a montagem de pipelines complexos de forma declarativa. O código lê-se como um roteiro, separando a "intenção" da "execução". | A fluent interface that allows for declarative assembly of complex pipelines. The code reads like a script, decoupling "intent" from "execution." |
| **Stateful Context** | Centraliza a mutação de dados em um objeto de estado único e thread-safe, garantindo que a informação flua sem efeitos colaterais entre as camadas do sistema. | Centralizes data mutation into a single, thread-safe state object, ensuring information flows without side effects across system layers. |
| **Circuit Breaking Logic** | Implementa mecanismos de segurança que interrompem o fluxo preventivamente em caso de erros sistêmicos, protegendo a integridade dos dados e recursos. | Implements safety mechanisms that preemptively halt the flow in case of systemic errors, protecting data integrity and resources. |
| **Atomic Tasks (SRP)** | Segue o Princípio de Responsabilidade Única (SRP), onde cada tarefa é uma unidade atômica, facilitando testes isolados e a manutenção de longo prazo. | Follows the Single Responsibility Principle (SRP), where each task is an atomic unit, facilitating isolated testing and long-term maintenance. |
| **Container-First Design** | Arquitetura pensada para ambientes efêmeros (Docker), garantindo que o orquestrador seja agnóstico à infraestrutura e fácil de escalar. | Architecture designed for ephemeral environments (Docker), ensuring the orchestrator is infrastructure-agnostic and easy to scale. |

---
##  Ferramentas & Requisitos / Requirements & Tools

### (PT-BR) Ecossistema de Desenvolvimento Detalhado
Nesta seção, exploramos as tecnologias que compõem a fundação do nosso Orquestrador. Cada ferramenta foi escolhida para transformar um script simples em uma solução de engenharia portátil, testável e resiliente.

* **Ruby 3.2+ (O Core)**: Mais do que apenas a linguagem, o Ruby 3.2 fornece a infraestrutura necessária para a nossa "execução governada". Utilizamos recursos de *Pattern Matching* para desestruturar respostas de APIs e o controle de exceções nativo para gerenciar o estado do sistema. O comando `retry` é o pilar do nosso motor de resiliência, permitindo a auto-cura de tarefas sem intervenção manual.
* **Bundler (Gestão de Dependências)**: Atua como o garantidor da consistência. Através do `Gemfile`, o Bundler assegura que bibliotecas críticas de teste e desenvolvimento tenham exatamente as mesmas versões em qualquer ambiente, eliminando o clássico erro "funciona na minha máquina".
* **Docker & Docker Compose (Infraestrutura como Código)**: O Docker encapsula o projeto em uma camada Linux leve (Debian Slim), isolando-o de conflitos do sistema operacional hospedeiro. O Docker Compose eleva o nível de maturidade ao orquestrar múltiplos serviços: ele gerencia a rede virtual que permite ao nosso código Ruby "conversar" com o banco de dados PostgreSQL como se estivessem na mesma máquina física.
* **PostgreSQL (Persistência de Dados)**: Representa a transição de dados voláteis para dados persistentes. O uso de um banco de dados real permite que o `DatabaseConnector` valide transações, garantindo que as informações processadas pelas Tasks sejam armazenadas de forma segura e estruturada.
* **RSpec (Garantia de Qualidade)**: É o coração da nossa estratégia de testes. Com o RSpec, validamos não apenas o sucesso das tarefas, mas principalmente o comportamento do `Engine` sob estresse ou falha, garantindo que o fluxo de retries e a integridade do `Context` permaneçam inalterados após qualquer refatoração.
* **Pry & Git (Suporte e Rastreabilidade)**: O Pry funciona como nosso "raio-x" em tempo real, permitindo pausar o pipeline para inspecionar o objeto `Context`. O Git fecha o ciclo garantindo que cada evolução da arquitetura seja documentada e possa ser revertida se necessário.

---

### (EN-US) Detailed Development Ecosystem
This section explores the technologies forming our Orchestrator's foundation. Each tool was selected to transform a simple script into a portable, testable, and resilient engineering solution.

* **Ruby 3.2+ (The Core)**: Beyond being just a language, Ruby 3.2 provides the infrastructure for our "governed execution." We leverage advanced *Pattern Matching* to deconstruct API responses and native exception handling to manage system states. The `retry` command is the backbone of our resilience engine, enabling self-healing tasks without manual intervention.
* **Bundler (Dependency Management)**: Acts as the consistency guarantor. Through the `Gemfile`, Bundler ensures that critical testing and development libraries have exact version parity across any environment, eliminating "it works on my machine" issues.
* **Docker & Docker Compose (Infrastructure as Code)**: Docker encapsulates the project within a lightweight Linux layer (Debian Slim), isolating it from host OS conflicts. Docker Compose raises the maturity level by orchestrating multiple services: it manages the virtual network that allows our Ruby code to "talk" to the PostgreSQL database seamlessly.
* **PostgreSQL (Data Persistence)**: Represents the transition from volatile to persistent data. Using a real database allows the `DatabaseConnector` to validate transactions, ensuring that information processed by Tasks is stored securely and structurally.
* **RSpec (Quality Assurance)**: The heart of our testing strategy. With RSpec, we validate not just task success, but primarily the `Engine` behavior under stress or failure, ensuring the retry flow and `Context` integrity remain intact after any refactoring.
* **Pry & Git (Support & Traceability)**: Pry serves as our real-time "X-ray," allowing us to pause the pipeline and inspect the `Context` object. Git closes the loop by ensuring every architectural evolution is documented and can be rolled back if needed.
  
---


##  Por que este projeto existe? / Why this project?

**(PT-BR)**
Este projeto é um estudo de caso sobre **Maturidade de Design**. Ele demonstra que a escolha da linguagem é secundária à qualidade da arquitetura. O foco aqui foi criar algo:
* **Extensível:** Você pode adicionar 100 novas tarefas sem tocar no código do motor central.
* **Testável:** Como as tarefas são isoladas, os testes de unidade tornam-se simples e rápidos.
* **Profissional:** Aplica padrões utilizados em sistemas de grande escala (como Sidekiq ou Trailblazer).

**(EN-US)**
This project is a case study on **Design Maturity**. It demonstrates that the choice of language is secondary to architectural quality. The focus here was to create something:
* **Extensible:** You can add 100 new tasks without touching the core engine code.
* **Testable:** Since tasks are isolated, unit tests become simple and fast.
* **Professional:** It applies patterns used in large-scale systems (like Sidekiq or Trailblazer).

---

##  Problema vs. Solução / Problem vs. Solution

### (PT-BR) O Desafio da Automação em Sistemas Distribuídos

Em arquiteturas modernas, um processo raramente é isolado. Ele depende de uma teia de microserviços, APIs de terceiros e bancos de dados. O grande problema é que **a rede é instável**. Um script linear trata o sucesso como a única opção, o que o torna perigoso para operações críticas.

#### O Problema: O "Efeito Dominó" e a Corrupção de Dados
Imagine um fluxo de **Onboarding de Usuário**:
1. **Banco de Dados**: Cria o registro (Estado: Sucesso).
2. **API Externa**: Gera licença de uso (Estado: Sucesso).
3. **Serviço de E-mail**: Falha por instabilidade de rede (Estado: **ERRO FATAL**).

**Consequência:** O script morre. O usuário está no banco, a licença foi consumida na API, mas o usuário nunca soube disso. Para consertar, um desenvolvedor terá que:
* Limpar o banco manualmente ou "ignorar" o erro.
* Tratar o suporte técnico do usuário frustrado.
* Lidar com a falta de logs: "Onde exatamente parou? O que já foi executado?".
* **Risco de Duplicidade:** Se você rodar o script de novo, ele tentará criar o usuário que já existe, gerando um erro de conflito no passo 1.

####  A Solução: Orquestração Baseada em Estado e Resiliência
O **Ruby Orchestrator** muda a lógica de "executar e torcer" para "governar e persistir".

* **Atomicidade Progressiva:** Cada tarefa é tratada como uma unidade. Se o passo 3 falha, o Maestro não desiste. Ele utiliza **Exponential Backoff** (espera um pouco e tenta de novo), resolvendo 90% das falhas de rede sem que ninguém perceba que houve um erro.
* **Persistência do Contexto:** Se o erro persistir após os retries, o objeto `Context` atua como uma "caixa preta" de avião. Ele armazena exatamente o que o passo 1 e 2 produziram.
* **Idempotência e Recuperação:** Você pode reiniciar o orquestrador fornecendo o contexto anterior. O Maestro detecta que os passos 1 e 2 já foram concluídos e retoma a execução **exatamente do ponto de falha** (Passo 3). 
* **Resultado:** Consistência total de dados, redução de 100% na intervenção manual para erros de rede e visibilidade completa do pipeline.

---

### (EN-US) The Challenge of Automation in Distributed Systems

In modern architectures, a process is rarely isolated. It depends on a web of microservices, third-party APIs, and databases. The core issue is: **the network is unreliable**. A linear script treats success as the only option, making it dangerous for mission-critical operations.

#### The Problem: The "Domino Effect" and Data Corruption
Imagine a **User Onboarding** flow:
1. **Database**: Creates the record (Status: Success).
2. **External API**: Generates a license key (Status: Success).
3. **Email Service**: Fails due to network jitter (Status: **FATAL ERROR**).

**Consequence:** The script crashes. The user exists in the DB, the license was consumed in the API, but the user never received the info. To fix this, a developer must:
* Manually clean the DB or "ignore" the ghost record.
* Handle support tickets from frustrated users.
* Deal with zero traceability: "Where exactly did it stop? What was already executed?".
* **Duplication Risk:** If you re-run the script, it will try to create a user that already exists, crashing at Step 1.

####  The Solution: State-Driven Orchestration and Resilience
**Ruby Orchestrator** shifts the logic from "execute and pray" to "govern and persist."

* **Progressive Atomicity:** Each task is an atomic unit. If Step 3 fails, the Conductor doesn't give up. It uses **Exponential Backoff** (waits and retries), resolving 90% of transient network issues silently.
* **Context Persistence:** If the error persists after all retries, the `Context` object acts like a flight's "black box." It stores exactly what Steps 1 and 2 produced.
* **Idempotency and Recovery:** You can restart the orchestrator by feeding it the previous context. The Conductor detects that Steps 1 and 2 are already finished and resumes execution **exactly from the point of failure** (Step 3).
* **Result:** Absolute data consistency, 100% reduction in manual intervention for network flakiness, and full pipeline visibility.

---

##  Explicação da Arquitetura / Architecture Deep Dive

### 1. Interactors & Command Pattern
**[PT-BR]** Cada tarefa é um "Interactor" independente. São peças de LEGO que podem ser trocadas ou movidas sem afetar o resto do sistema.
**[EN-US]** Each Task is an independent "Interactor." They are LEGO pieces that can be swapped or moved without affecting the rest of the system.

### 2. State Management (The Context)
**[PT-BR]** Utilizamos um objeto de **Contexto Compartilhado**. Se uma tarefa falha, o contexto preserva o erro para análise posterior, evitando acoplamento entre funções.
**[EN-US]** We use a **Shared Context** object. If a task fails, the context preserves the error for later analysis, avoiding coupling between functions.

### 3. Native Resilience Logic
**[PT-BR]** Utilizamos o comando `retry` nativo do Ruby para criar um sistema de "auto-cura" com recuo exponencial.
**[EN-US]** We leverage Ruby's native `retry` command to create a "self-healing" system with exponential backoff.

---




##  Contribuição / Contributing

1. **Fork** o projeto / Fork the project.
2. Crie uma **Branch** para sua funcionalidade / Create your feature branch.
3. **Commit** suas mudanças com mensagens claras / Commit your changes with clear messages.
4. Abra um **Pull Request** detalhando as melhorias / Open a detailed Pull Request.

---

##  Licença / License

Distribuído sob a licença **MIT**. Este projeto é livre para uso acadêmico ou comercial.
Distributed under the **MIT License**. This project is free for academic or commercial use.

---
