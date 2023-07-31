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
    end
  end
end
