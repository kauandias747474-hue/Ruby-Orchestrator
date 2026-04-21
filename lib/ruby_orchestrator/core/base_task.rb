module RubyOrchestrator
  module Core
    class BaseTask
      def perform(context)
        raise NotImplementedError
      end
    end
  end
end
