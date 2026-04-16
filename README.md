#  Ruby Orchestrator

![Ruby Version](https://img.shields.io/badge/ruby-3.2%2B-red.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![Architecture](https://img.shields.io/badge/arch-Service--Oriented-blue.svg)

> **(PT-BR)** Um maestro de processos resiliente que transforma fluxos de dados complexos em pipelines elegantes e à prova de falhas.
>
> **(EN-US)** A resilient process conductor that transforms complex data flows into elegant, fail-safe pipelines.

---

## 📑 Índice / Table of Contents
- [A Visão / The Vision](#-a-visão--the-vision)
- [Arquitetura / Architecture](#-arquitetura--architecture)
- [Diferenciais / Key Features](#-diferenciais--key-features)
- [Instalação / Installation](#-instalação--installation)
- [Exemplo de Uso / Usage Example](#-exemplo-de-uso--usage-example)
- [Por que este projeto? / Why this project?](#-por-que-este-projeto--why-this-project)

---

## 🎯 A Visão / The Vision

### (PT-BR)
O **Ruby Orchestrator** não é apenas um script; é uma infraestrutura lógica. Ele foi criado para resolver o problema de scripts lineares que "quebram no meio" sem deixar rastros. Ele atua como um **Maestro**, garantindo que cada tarefa (Task) seja executada na ordem correta, com os dados corretos e com inteligência para tentar novamente em caso de erro.

### (EN-US)
**Ruby Orchestrator** isn't just a script; it's a logical infrastructure. It was built to solve the issue of linear scripts that "break in the middle" without leaving a trace. It acts as a **Conductor**, ensuring each Task is executed in the correct order, with the correct data, and with the intelligence to retry upon failure.

---

## 🏗️ Arquitetura / Architecture

O projeto utiliza o padrão de **Interactors** e um **Contexto Compartilhado**, eliminando a necessidade de passar inúmeros argumentos entre funções.



## 🛠️ Diferenciais / Key Features

| Feature | Description (PT-BR) | Description (EN-US) |
| :--- | :--- | :--- |
| **Native Retry** | Tenta executar novamente tarefas que falharam. | Automatically retries failed tasks. |
| **Fluent DSL** | Interface limpa e legível (Method Chaining). | Clean and readable fluent interface. |
| **State Management** | Contexto único que viaja por todo o pipeline. | Single context object throughout the pipeline. |
| **Error Isolation** | Se uma tarefa falha criticamente, o maestro para. | Critical failures trigger a clean circuit break. |

---

## 👨‍💻 Por que este projeto? / Why this project?

Este projeto foi desenvolvido para demonstrar competência em **Design de Software**, mesmo para quem não tem o Ruby como stack principal. Ele foca em:

1.  **Desacoplamento:** As tarefas não sabem da existência umas das outras.
2.  **Manutenibilidade:** Adicionar um novo passo ao processo leva segundos.
3.  **Padrões de Elite:** Aplicação rigorosa de SOLID e Clean Code.

---

## 🤝 Contribuição / Contributing

1. **Fork** o projeto.
2. Crie uma **Feature Branch** (`git checkout -b feature/AmazingFeature`).
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`).
4. **Push** para a Branch (`git push origin feature/AmazingFeature`).
5. Abra um **Pull Request**.

---

## 📜 Licença / License

Distributed under the **MIT License**. Veja `LICENSE` para mais informações.


### 📂 Organização / Organization
```text
ruby_orchestrator/
├── bin/             # CLI entry point
├── lib/
│   ├── core/        # The "Brain": Engine & Context handler
│   ├── tasks/       # The "Musicians": Atomic units of work
│   └── connectors/  # The "Instruments": API/DB Adapters
└── spec/            # The "Judge": Unit & Integration tests
