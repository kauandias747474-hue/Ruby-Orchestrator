
ROOT_PATH = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(ROOT_PATH, 'lib'))


puts "--- [SISTEMA] Carregando Infraestrutura ---"

begin

  require 'ruby_orchestrator/core/context'
  require 'ruby_orchestrator/core/base_task'
  require 'ruby_orchestrator/core/engine'
  

  require 'ruby_orchestrator/connectors/database_connector'
  

  require 'ruby_orchestrator/tasks/fetch_api_task'
  require 'ruby_orchestrator/tasks/process_data_task'
  require 'ruby_orchestrator/core/test_task'

  puts " Sucesso: Todos os componentes carregados!"
rescue LoadError => e
  puts " Erro Fatal de Carregamento: #{e.message}"
  exit
end


puts "\n--- [MAESTRO] Configurando Fluxo de Execução ---"
maestro = RubyOrchestrator::Core::Engine.new


maestro.add_task(RubyOrchestrator::Tasks::FetchApiTask, retries: 2)
maestro.add_task(RubyOrchestrator::Tasks::ProcessDataTask, retries: 1)
maestro.add_task(RubyOrchestrator::Core::TestTask, retries: 3)

puts "--- [EXECUÇÃO] Iniciando Processamento Ativo ---\n"
start_time = Time.now

begin
  maestro.run!
rescue StandardError => e
  puts "\n[CRÍTICO] Falha catastrófica no motor: #{e.message}"
end

end_time = Time.now


ctx = maestro.instance_variable_get(:@context)

puts "\n" + "="*45
puts "         RELATÓRIO FINAL DO ORQUESTRADOR"
puts "="*45
puts "Status Final:      #{ctx[:status] || 'INDETERMINADO'}"
puts "Duração:           #{(end_time - start_time).round(4)}s"
puts "Usuário Detectado: #{ctx[:user_name] || 'N/A'}"
puts "Dados Processados: #{ctx[:processed_info] ? 'SIM' : 'NÃO'}"
if ctx[:error_log]
  puts "Último Erro:       #{ctx[:error_log]}"
end
puts "="*45
