module RubyOrchestrator
    module Core
        class Context
            def initialize
                @data = {}
            end

            def []=(key, value)
            @data[key] = value
            end

            def[](key)
              @data[key]
            end

            def inspect
                @data.inspect
            end
        end
    end
end
