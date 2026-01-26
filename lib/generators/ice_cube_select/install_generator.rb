require "rails/generators"

module IceCubeSelect
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/assets", __FILE__)

      desc "Copies ice_cube_select assets to your application for use with Propshaft"

      def copy_stylesheets
        copy_file "stylesheets/ice_cube_select.css",
          "app/assets/stylesheets/ice_cube_select.css"
      end

      def copy_javascripts
        copy_file "javascripts/ice_cube_select.js",
          "app/assets/javascripts/ice_cube_select.js"
        copy_file "javascripts/ice_cube_select_dialog.js",
          "app/assets/javascripts/ice_cube_select_dialog.js"
      end

      def show_readme
        return unless behavior == :invoke

        install_path = File.join(File.dirname(__FILE__), "INSTALL")
        if File.exist?(install_path)
          say File.read(install_path), :green
        end
      end
    end
  end
end
