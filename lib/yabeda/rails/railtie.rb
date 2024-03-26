# frozen_string_literal: true

# Explicitly require yabeda's railtie in case if its require was skipped there.
# See https://github.com/yabeda-rb/yabeda/issues/15
require "yabeda/railtie"

module Yabeda
  module Rails
    class Railtie < ::Rails::Railtie # :nodoc:
      def rails_server?
        ::Rails.const_defined?(:Server)
      end

      def puma_server?
        ::Rails.const_defined?("Puma::CLI")
      end

      def unicorn_server?
        ::Rails.const_defined?("Unicorn::Launcher")
      end
      
      def passenger_server?
        ::Rails.const_defined?("PhusionPassenger")
      end

      initializer "yabeda-rails.metrics" do
        ::Yabeda::Rails.install! if rails_server? || puma_server? || unicorn_server? || passenger_server?
      end
    end
  end
end
