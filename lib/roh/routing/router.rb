module Roh
  module Routing
    class Router
      attr_accessor :endpoints

      def initialize
        @endpoints ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def draw(&block)
        instance_eval(&block)
      end

      def root(address)
        get "/", to: address
      end

      [:get, :post, :put, :patch, :delete].each do |method_name|
        define_method(method_name) do |url, *options|
          route_data = {
            path: url,
            pattern: pattern_for(url),
            controller_and_action: controller_and_action(options)
          }
          endpoints[method_name] << route_data
        end
      end

      def pattern_for(path)
        placeholders = []
        new_path = path.gsub(/(:\w+)/) do |match|
          placeholders << match[1..-1].freeze
          "(?<#{placeholders.last}>[^?/#]+)"
        end
        [/^#{new_path}$/, placeholders]
      end

      def controller_and_action(options)
        controller_and_action = options.shift[:to].split("#")
        controller_name, action = controller_and_action
        controller = controller_name.to_camel_case + "Controller"
        [controller, action]
      end
    end
  end
end
