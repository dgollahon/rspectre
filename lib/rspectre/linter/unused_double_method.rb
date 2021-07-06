# frozen_string_literal: true

module RSpectre
  class Linter
    class UnusedDoubleMethod < self
      TAG = 'UnusedDoubleMethod'

      def self.hijack_doubleish_thing(method_name)
        # TODO: what about other potential side-effects like respond_to? (?)
        original_method = mocks.instance_method(method_name)
        mocks.define_method(method_name) do |name, **stubs| # TODO: check if non-kwargs works ?
          method_location = caller_locations.first

          double = original_method.bind(self).(name)

          stubs.each do |doubled_method_name, value|
            node =
              UnusedDoubleMethod.find_kwarg(
                method_name,
                doubled_method_name,
                method_location
              )

              TRACKER.register(TAG, node)

              allow(double).to receive(doubled_method_name) do
                UnusedDoubleMethod.record(node)

                value
              end
            end

            double
          end
      end

      hijack_doubleish_thing(:double)
      hijack_doubleish_thing(:instance_double)
      hijack_doubleish_thing(:class_double)
      hijack_doubleish_thing(:instance_spy)
      hijack_doubleish_thing(:class_spy)
    end
  end
end
