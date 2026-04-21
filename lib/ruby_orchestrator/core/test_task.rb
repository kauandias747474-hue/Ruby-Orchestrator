module RubyOrchestrator
  module Core
    class TestTask < BaseTask
    
      def perform(context)
        puts "\n[Task: TestTask] -> Iniciando unidade de trabalho..."
        

        db = RubyOrchestrator::Connectors::DatabaseConnector.new(connection_name: "PostgreSQL_Main")
        
      
        begin
        
          db.connect
          
          user = db.find_user(42)
          
          puts "[Task: TestTask] -> Processando dados do usuário: #{user[:name]}"
          context[:user_id] = user[:id]
          context[:user_name] = user[:name]
          context[:processed_at] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
          

          context[:status] = "CONCLUÍDO_COM_SUCESSO"
          
        rescue StandardError => e
      
          context[:failed_at] = Time.now
          context[:error_message] = e.message
          puts " [Task: TestTask] -> Falha operacional detectada: #{e.message}"
          

          raise e
        ensure

          db.disconnect if db
          puts "[Task: TestTask] -> Recursos liberados."
        end
      end
    end
  end
end
