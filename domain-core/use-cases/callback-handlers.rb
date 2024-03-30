module DomainCore
  module UseCases
    class CallbackHandlers
      attr_accessor :on_success, :on_failure

      def on_success_handler(result)
        on_success.call(result)
      end

      def on_failure_handler(result)
        on_failure.call(result)
      end
    end
  end
end
