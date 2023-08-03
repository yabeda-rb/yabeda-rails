# frozen_string_literal: true

require "anyway"

module Yabeda
  module Rails
    class Config < ::Anyway::Config
      config_name :yabeda_rails

      attr_config :apdex_target
      attr_config controller_name_case: :snake
    end
  end
end
