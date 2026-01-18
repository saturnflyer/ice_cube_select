require "spec_helper"

RSpec.describe "IceCubeSelect Dialog", type: :system, js: true do
  before do
    visit root_path
  end

  describe "opening the dialog" do
    it "opens when clicking on a select field" do
      first("select.ice_cube_select").select("Set schedule...")

      expect(page).to have_css(".ice_cube_select_dialog_holder")
      expect(page).to have_content("Repeat")
    end
  end

  describe "dialog interactions" do
    before do
      first("select.ice_cube_select").select("Set schedule...")
    end

    it "allows changing frequency" do
      select "Weekly", from: "ice_cube_select_frequency"

      expect(page).to have_css(".weekly_options", visible: true)
      expect(page).to have_css(".day_holder")
    end

    it "closes when clicking cancel" do
      click_button "Cancel"

      expect(page).not_to have_css(".ice_cube_select_dialog_holder")
    end

    it "closes when clicking the X button" do
      find(".ice_cube_select_dialog_content h4 a").click

      expect(page).not_to have_css(".ice_cube_select_dialog_holder")
    end
  end

  describe "weekly options" do
    before do
      first("select.ice_cube_select").select("Set schedule...")
      select "Weekly", from: "ice_cube_select_frequency"
    end

    it "allows selecting days of the week" do
      within(".day_holder") do
        find("a", text: "M").click
        find("a", text: "W").click
        find("a", text: "F").click
      end

      expect(page).to have_css(".day_holder a.selected", count: 3)
    end

    it "does not expand the dialog width when clicking days" do
      dialog = find(".ice_cube_select_dialog")
      initial_width = dialog.native.bounding_box["width"]

      within(".day_holder") do
        find("a", text: "M", exact_text: true).click
        find("a", text: "W", exact_text: true).click
        find("a", text: "F", exact_text: true).click
      end

      final_width = dialog.native.bounding_box["width"]
      expect(final_width).to be <= initial_width
    end
  end

  describe "monthly options" do
    before do
      first("select.ice_cube_select").select("Set schedule...")
      select "Monthly", from: "ice_cube_select_frequency"
    end

    it "shows day of month calendar by default" do
      expect(page).to have_css(".ice_cube_select_calendar_day", visible: true)
    end

    it "allows selecting multiple days of the month" do
      within(".ice_cube_select_calendar_day") do
        find("a", text: "1", exact_text: true).click
        find("a", text: "15", exact_text: true).click
      end

      expect(page).to have_css(".ice_cube_select_calendar_day a.selected", count: 2)
    end

    it "does not expand the dialog width when selecting many days" do
      dialog = find(".ice_cube_select_dialog")
      initial_width = dialog.native.bounding_box["width"]

      within(".ice_cube_select_calendar_day") do
        (1..10).each { |day| find("a", text: day.to_s, exact_text: true).click }
      end

      final_width = dialog.native.bounding_box["width"]
      expect(final_width).to be <= initial_width
    end
  end

  describe "saving a rule" do
    it "saves and updates the select field" do
      first("select.ice_cube_select").select("Set schedule...")
      select "Weekly", from: "ice_cube_select_frequency"

      within(".day_holder") do
        find("a", text: "M").click
      end

      click_button "OK"

      expect(page).not_to have_css(".ice_cube_select_dialog_holder")
    end
  end
end
