module RubyOrchestrator
    module Connectors
        class DatabaseConnectors
            attr_reader :connection_name

            def initialize(connection_name: "Production_DB")
                @connection_name = connection_name
                @connected = false
            end

            def connect
                puts "Conectando ao banco [#{@connection_name}]..."

                if rand < 0.3
                    raise "Timeout: O banco de dados não conseguiu responder a tempo suficiente.."
                end

                @connected = true
                puts "A Conexão foi estabelecida."
            end

            def find_user(id)
                check_connection!

                { id: id, name: "Usuário Teste", email: "teste@example.com"}
            end 

            
            def disconnect
                @connected = false
                puts " Conexão com [#{@connection_name}] foi encerrada."
            end

            private

            def check_connection!
                unless @connected
                    raise "Erro de Runtime: Tentativa de consulta sem conexão ativa."
                end
            end
        end
    end
end
