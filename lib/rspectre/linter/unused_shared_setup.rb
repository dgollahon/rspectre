# frozen_string_literal: true

module RSpectre
  class Linter
    class UnusedSharedSetup < self
      TAG = 'UnusedSharedSetup'

      def self.redefine_shared(receiver, method)
        # Capture the original class method
        original_method = receiver.method(method)

        # Overwrite the class method using define_singleton_method
        receiver.send(:define_singleton_method, method) do |name, *args, &block|
          # When we can locate the source of the node, tag it
          if (node = UnusedSharedSetup.register(method, caller_locations))
            # And call the orignal
            original_method.(name, *args) do |*shared_args|
              # But record that it was used in a `before`
              before { UnusedSharedSetup.record(node) }

              # And then perform the original block in a `class_exec` like the original block was
              # supposed to be
              class_exec(*shared_args, &block)
            end
          else
            # If we couldn't locate the source, just delegate to the original method.
            original_method.(name, *args, &block)
          end
        end
      end

      if respond_to?(:shared_examples)
        main = TOPLEVEL_BINDING.eval('self')
        redefine_shared(main, :shared_examples)
        redefine_shared(main, :shared_examples_for)
        redefine_shared(main, :shared_context)
      end

      redefine_shared(RSpec, :shared_examples)
      redefine_shared(RSpec, :shared_examples_for)
      redefine_shared(RSpec, :shared_context)

      # We cannot dynamically capture the original method for the example group like we can for the
      # binding on main and for the RSpec constant because RSpec checks to see if the receiver of
      # the method is the top level example group which would be the case if we redefined it in
      # terms of the old method. I think we can probably do some kind of module inclusion to reduce
      # this duplication (which is effectively what happens here anyway, i think), but this works
      # for now.
      def example_group.shared_examples(name, *args, &block)
        if (node = UnusedSharedSetup.register(:shared_examples, caller_locations))
          super(name, *args) do |*shared_args|
            before { UnusedSharedSetup.record(node) }

            class_exec(*shared_args, &block)
          end
        else
          super(name, *args, &block)
        end
      end

      def example_group.shared_examples_for(name, *args, &block)
        if (node = UnusedSharedSetup.register(:shared_examples_for, caller_locations))
          super(name, *args) do |*shared_args|
            before { UnusedSharedSetup.record(node) }

            class_exec(*shared_args, &block)
          end
        else
          super(name, *args, &block)
        end
      end

      def example_group.shared_context(name, *args, &block)
        if (node = UnusedSharedSetup.register(:shared_context, caller_locations))
          super(name, *args) do |*shared_args|
            before { UnusedSharedSetup.record(node) }

            class_exec(*shared_args, &block)
          end
        else
          super(name, *args, &block)
        end
      end
    end
  end
end
