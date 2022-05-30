module Yabeda
  module Rails
    module ActionControllerDefaultTags
      def process_action(*args)
        Yabeda.with_tags(controller: controller_name, action: action_name) do
          super
        end
      end
    end
  end
end
