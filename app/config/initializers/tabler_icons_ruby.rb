# frozen_string_literal: true

require "tabler_icons_ruby"

ActiveSupport.on_load(:action_view) do
  include TablerIconsRuby::Helper
end
