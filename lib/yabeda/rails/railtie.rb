# frozen_string_literal: true

module Yabeda
  module Rails
    class Railtie < ::Rails::Railtie # :nodoc:
      config.after_initialize do
        next unless ::Rails.const_defined?(:Server)

        ::Yabeda::Rails.install!
      end
    end
  end
end
