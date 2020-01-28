# frozen_string_literal: true

module Yabeda
  module Rails
    class Railtie < ::Rails::Railtie # :nodoc:
      def rails_server?
        ::Rails.const_defined?(:Server)
      end

      def puma_server?
        ::Rails.const_defined?('Puma::CLI')
      end

      config.after_initialize do
        ::Yabeda::Rails.install! if rails_server? || puma_server?
        Yabeda.configure! unless Yabeda.already_configured?
      end
    end
  end
end
