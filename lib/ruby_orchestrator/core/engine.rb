module RubyOrchestrator
  module Core
    class Engine
      def initialize
        @tasks = []
        @context = RubyOrchestrator::Core::Context.new
      end

      def add_task(task_class, retries: 0)
        @tasks << { class: task_class, retries: retries }
      end

      def run!
        puts " Maestro iniciando a execução..."

        @tasks.each do |item|
          attempts = 0
          begin
            item[:class].new.perform(@context)
          rescue StandardError => e
            if attempts < item[:retries]
              attempts += 1
              puts " Falha em #{item[:class]}. Tentativa #{attempts}. Tentando novamente..."
              retry
            else
              puts " Erro definitivo em #{item[:class]}: #{e.message}"
              break
            end
          end
        end

        puts "🏁 Fim da execução. Estado final: #{@context.inspect}"
      end
    end
  end
end
