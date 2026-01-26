require "spec_helper"
require "rails/generators/test_case"
require "generators/ice_cube_select/install_generator"
require "fileutils"

describe IceCubeSelect::Generators::InstallGenerator do
  include FileUtils

  let(:destination) { File.expand_path("../../../tmp/generator_test", __dir__) }

  before do
    rm_rf(destination) if File.exist?(destination)
    mkdir_p(destination)
  end

  after do
    rm_rf(destination) if File.exist?(destination)
  end

  it "copies the CSS file to app/assets/stylesheets" do
    Dir.chdir(destination) do
      IceCubeSelect::Generators::InstallGenerator.start(["--skip-readme"], destination_root: destination)

      css_path = File.join(destination, "app/assets/stylesheets/ice_cube_select.css")
      expect(File.exist?(css_path)).to be true
    end
  end

  it "copies the JavaScript files to app/assets/javascripts" do
    Dir.chdir(destination) do
      IceCubeSelect::Generators::InstallGenerator.start(["--skip-readme"], destination_root: destination)

      js_path = File.join(destination, "app/assets/javascripts/ice_cube_select.js")
      dialog_path = File.join(destination, "app/assets/javascripts/ice_cube_select_dialog.js")

      expect(File.exist?(js_path)).to be true
      expect(File.exist?(dialog_path)).to be true
    end
  end

  it "copies files with correct content" do
    Dir.chdir(destination) do
      IceCubeSelect::Generators::InstallGenerator.start(["--skip-readme"], destination_root: destination)

      css_content = File.read(File.join(destination, "app/assets/stylesheets/ice_cube_select.css"))
      expect(css_content).to include("IceCubeSelect")

      js_content = File.read(File.join(destination, "app/assets/javascripts/ice_cube_select.js"))
      expect(js_content).not_to be_empty

      dialog_content = File.read(File.join(destination, "app/assets/javascripts/ice_cube_select_dialog.js"))
      expect(dialog_content).not_to be_empty
    end
  end
end
