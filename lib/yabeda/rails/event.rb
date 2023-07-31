# frozen_string_literal: true

module Yabeda
  module Rails
    class Event < ActiveSupport::Notifications::Event
      def controller
        case Yabeda::Rails.config.controller_name_case
        when :snake
          payload[:params]["controller"]
        when :camel
          payload[:controller]
        end
      end

      def status_code
        if payload[:status].nil? && payload[:exception].present?
          ActionDispatch::ExceptionWrapper.status_code_for_exception(payload[:exception].first)
        else
          payload[:status]
        end
      end
    end
  end
end
