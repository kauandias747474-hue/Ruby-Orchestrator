module RubyOrchestrator
    module Tasks
        class FetchApiTask < RubyOrchestrator::Core::BaseTask
          def perform(context)
        puts "[Task: FetchApi] -> Buscando dados da API externa..."
        
        response_data = { 
          id: 101, 
          raw_payload: "sensor_id=A1;temp=22.5;status=ok",
          provider: "WeatherAPI"
        }

        
     context[:api_response] = response_data
        context[:status] = "DATA_FETCHED"
        puts "[Task: FetchApi] -> Dados armazenados no contexto."
      end
    end
  end
end

