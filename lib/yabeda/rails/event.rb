# frozen_string_literal: true

module Yabeda
  module Rails
    # ActiveSupport Event with added logic for Yabeda tags formatting
    class Event < ActiveSupport::Notifications::Event
      def labels
        @labels ||= begin
          labels = {
            controller: controller,
            action: action,
            status: status,
            format: format,
            method: method,
          }
          labels.merge(payload.slice(*Yabeda.default_tags.keys - labels.keys))
        end
      end

      def duration
        ms2s super
      end

      def view_runtime
        ms2s payload[:view_runtime]
      end

      def db_runtime
        ms2s payload[:db_runtime]
      end

      private

      def controller
        case Yabeda::Rails.config.controller_name_case
        when :camel
          payload[:controller]
        else
          payload[:params]["controller"]
        end
      end

      def action
        payload[:action]
      end

      def status
        if payload[:status].nil? && payload[:exception].present?
          ActionDispatch::ExceptionWrapper.status_code_for_exception(payload[:exception].first)
        else
          payload[:status]
        end
      end

      def format
        payload[:format]
      end

      def method
        payload[:method].downcase
      end

      def ms2s(milliseconds)
        (milliseconds.to_f / 1000).round(3)
      end
    end
  end
end
