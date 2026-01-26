# frozen_string_literal: true

require "anyway"

module Yabeda
  module Rails
    # yabeda-rails configuration
    class Config < ::Anyway::Config
      config_name :yabeda_rails

      attr_config :apdex_target
      attr_config :buckets
      attr_config controller_name_case: :snake
      attr_config ignore_actions: []
      attr_config group_name: :rails
    end
  end
end
