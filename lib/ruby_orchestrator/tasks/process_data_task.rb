module RubyOrchestrator
    module Tasks
        class ProcessDataTask < RubyOrchestrator::Core::BaseTask
            def perform(context)
        puts "[TASK: ProcessData] -> Transformando em dados brutos.."


        raw = context[:api_response][:raw_payload]

        parts = raw.split(';')
        processed = {}
        parts.each do |part|
            key, value = part.split('=')
            processed[key.to_sym] = value
        end
     

        context[:processed_info] = processed
        context[:status] = "COMPLETED"
        puts "[Task: ProcessData] -> Transformação concluída: #{processed.inspect}"
       end
    end
   end
end

