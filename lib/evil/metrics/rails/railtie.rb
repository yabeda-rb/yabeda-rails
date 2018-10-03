# frozen_string_literal: true

module Evil
  module Metrics
    module Rails
      class Railtie < ::Rails::Railtie # :nodoc:
        config.after_initialize do
          next unless ::Rails.const_defined?(:Server)

          ::Evil::Metrics::Rails.install!
        end
      end
    end
  end
end
