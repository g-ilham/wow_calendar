module System
  class CallSomeMethods
    class << self
      def call_in_methods(some_methods, trigger_class, with_break=false)
        some_methods.each do |method_name|
          trigger_class.send(method_name.to_sym)

          if with_break
            break if trigger_class.errors.present?
          end
        end
      end
    end
  end
end
