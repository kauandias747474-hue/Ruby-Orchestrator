#  Ruby Orchestrator

![Ruby Version](https://img.shields.io/badge/ruby-3.2%2B-red)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Architecture](https://img.shields.io/badge/architecture-Service_Pattern-orange)
![Docker Support](https://img.shields.io/badge/docker-ready-blue?logo=docker)

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

### 1. Interactors & Command Pattern
**(PT-BR)** Cada tarefa (Task) é um "Interactor" independente. Isso significa que a lógica de "enviar um e-mail" nunca se mistura com a lógica de "validar um CPF". Elas são peças de LEGO que podem ser trocadas ou movidas sem afetar o resto do sistema.
**(EN-US)** Each Task is an independent "Interactor." This means the logic for "sending an email" never mixes with the logic for "validating a tax ID." They are LEGO pieces that can be swapped or moved without affecting the rest of the system.

### 2. State Management (The Context)
**(PT-BR)** Utilizamos um objeto de **Contexto Compartilhado**. Em vez de funções passarem múltiplos parâmetros umas para as outras (o que gera acoplamento), elas apenas leem e escrevem em uma "caixa" central que viaja pelo pipeline. Se uma tarefa falha, o contexto preserva o erro para análise posterior.
**(EN-US)** We use a **Shared Context** object. Instead of functions passing multiple parameters to one another (which creates coupling), they simply read and write to a central "box" that travels through the pipeline. If a task fails, the context preserves the error for later analysis.

### 3. Native Resilience Logic
**(PT-BR)** Diferente de outras linguagens, o Ruby possui o comando `retry`. Nosso motor utiliza essa capacidade nativa para criar um sistema de "auto-cura". Se uma API externa oscilar, o Orchestrator tenta novamente automaticamente, aumentando a taxa de sucesso do software sem intervenção humana.
**(EN-US)** Unlike other languages, Ruby features a native `retry` command. Our engine utilizes this built-in capability to create a "self-healing" system. If an external API flickers, the Orchestrator retries automatically, increasing software success rates without human intervention.

---

## 🛠️ Diferenciais Técnicos / Key Features

| Recurso / Feature | Explicação Detalhada (PT-BR) | Detailed Explanation (EN-US) |
| :--- | :--- | :--- |
| **Native Retry** | Implementa recuo exponencial para falhas em serviços externos. | Implements exponential backoff logic for external service failures. |
| **Fluent DSL** | Permite configurar pipelines complexos em uma única linha legível. | Allows configuring complex pipelines in a single, readable line. |
| **Circuit Breaking** | Protege o sistema interrompendo a execução se um erro fatal ocorrer. | Protects the system by halting execution if a fatal error occurs. |
| **Atomic Tasks** | Garante que cada classe tenha apenas uma razão para mudar (SRP). | Ensures each class has only one reason to change (SRP). |

---
## 🛠️ Ferramentas Necessárias / Requirements & Tools

### (PT-BR) Recursos para Desenvolvimento
* **Ruby 3.2+**: A linguagem base (utilizamos recursos modernos de pattern matching).
* **Bundler**: Para gerenciamento de dependências.
* **RSpec**: Framework de testes para garantir a saúde do Maestro.
* **Pry**: Para depuração em tempo real dentro do pipeline.
* **Git**: Controle de versão e colaboração.

### (EN-US) Development Tools
* **Ruby 3.2+**: The core language (leveraging modern pattern matching features).
* **Bundler**: For dependency management.
* **RSpec**: Testing framework to ensure the Conductor's health.
* **Pry**: For real-time debugging inside the pipeline.
* **Git**: Version control and collaboration.
  
---


## 👨‍💻 Por que este projeto existe? / Why this project?

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


##  Problema vs. Solução / Problem vs. Solution

### (PT-BR) Onde isso se aplica?
Imagine um fluxo de **Onboarding de Usuário**:
1. Criar conta no Banco de Dados.
2. Gerar chave de API em serviço externo.
3. Enviar e-mail de boas-vindas.
4. Notificar o time de vendas no Slack.

* **Sem o Orchestrator:** Se o serviço de e-mail cair (passo 3), o usuário é criado, mas o processo "quebra". Você fica com dados inconsistentes e sem saber onde parou.
* **Com o Orchestrator:** Se o passo 3 falhar, o sistema executa o `retry` automático. Se a falha persistir, ele salva o estado atual (**Context**), permitindo que você reinicie exatamente do ponto de falha sem duplicar os passos 1 e 2.

### (EN-US) Real-world Application
Imagine a **User Onboarding** flow:
1. Create account in the Database.
2. Generate API key in an external service.
3. Send welcome email.
4. Notify sales team on Slack.

* **Without the Orchestrator:** If the email service is down (step 3), the user is created but the process "crashes." You end up with inconsistent data and no idea where it failed.
* **With the Orchestrator:** If step 3 fails, the system triggers an automatic `retry`. If it still fails, it saves the current state (**Context**), allowing you to resume exactly from the point of failure without duplicating steps 1 and 2.

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
