
require 'spec_helper'


RSpec.describe RubyOrchestrator::Core::Engine do 
    let(:engine) { described_class.new }

    class FakeTask < RubyOrchestrator::Core::BaseTask
        def  perform(context); context[:worked] = true; end
    end

    it "deve executar uma tarefa adicionada com sucesso" do
        engine.add_task(FakeTask)
        engine.run!
        expect(engine.instance_variable_get(:@context)[:worked]).to be true
    end

    it "deve respeitar o número de retries em caso de falha" do

    end
end 
