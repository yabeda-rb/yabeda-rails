# frozen_string_literal: true

require "yabeda"
require "active_support"
require "rails/railtie"
require "yabeda/rails/railtie"
require "yabeda/rails/config"
require "yabeda/rails/event"

module Yabeda
  # Minimal set of Rails-specific metrics for using with Yabeda
  module Rails
    LONG_RUNNING_REQUEST_BUCKETS = [
      0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, # standard
      30, 60, 120, 300, 600, # Sometimes requests may be really long-running
    ].freeze

    class << self
      def controller_handlers
        @controller_handlers ||= []
      end

      def on_controller_action(&block)
        controller_handlers << block
      end

      # Declare metrics and install event handlers for collecting themya
      # rubocop: disable Metrics/MethodLength, Metrics/BlockLength, Metrics/AbcSize
      def install!
        Yabeda.configure do
          config = ::Yabeda::Rails.config
          buckets = config.buckets || LONG_RUNNING_REQUEST_BUCKETS
          group config.group_name

          counter   :requests_total,   comment: "A counter of the total number of HTTP requests rails processed.",
                                       tags: %i[controller action status format method]

          histogram :request_duration, tags: %i[controller action status format method],
                                       unit: :seconds,
                                       buckets: buckets,
                                       comment: "A histogram of the response latency."

          histogram :view_runtime, unit: :seconds, buckets: buckets,
                                   comment: "A histogram of the view rendering time.",
                                   tags: %i[controller action status format method]

          histogram :db_runtime, unit: :seconds, buckets: buckets,
                                 comment: "A histogram of the activerecord execution time.",
                                 tags: %i[controller action status format method]

          if config.apdex_target
            gauge :apdex_target, unit: :seconds,
                                 comment: "Tolerable time for Apdex (T value: maximum duration of satisfactory request)"
            collect { Yabeda::Rails.metric_group.apdex_target.set({}, config.apdex_target) }
          end

          ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
            event = Yabeda::Rails::Event.new(*args)

            # rubocop: disable Style/CaseEquality
            next if Array(config.ignore_actions).any? { |action| action === event.controller_action }
            # rubocop: enable Style/CaseEquality

            Yabeda::Rails.metric_group.requests_total.increment(event.labels)
            Yabeda::Rails.metric_group.request_duration.measure(event.labels, event.duration)
            Yabeda::Rails.metric_group.view_runtime.measure(event.labels, event.view_runtime)
            Yabeda::Rails.metric_group.db_runtime.measure(event.labels, event.db_runtime)

            Yabeda::Rails.controller_handlers.each do |handler|
              handler.call(event, event.labels)
            end
          end
        end
      end
      # rubocop: enable Metrics/MethodLength, Metrics/BlockLength, Metrics/AbcSize

      def config
        @config ||= Config.new
      end

      def metric_group
        Yabeda.groups[config.group_name]
      end
    end
  end
end
