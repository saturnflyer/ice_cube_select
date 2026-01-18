require "helpers/ice_cube_select_helper"
require "middleware/ice_cube_select_middleware"

module IceCubeSelect
  class Engine < Rails::Engine
    initializer "ice_cube_select.extending_form_builder" do |app|
      ActionView::Helpers::FormHelper.include(IceCubeSelectHelper::FormHelper)
      ActionView::Helpers::FormOptionsHelper.include(IceCubeSelectHelper::FormOptionsHelper)
      ActionView::Helpers::FormBuilder.include(IceCubeSelectHelper::FormBuilder)
    end

    initializer "ice_cube_select.connecting_middleware" do |app|
      app.middleware.use IceCubeSelectMiddleware
    end
  end
end
