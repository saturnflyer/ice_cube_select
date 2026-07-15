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

  describe "anchored monthly options" do
    it "shows the anchored section, saves a custom pattern, and prefills it on reopen" do
      select_field = first("select.ice_cube_select")
      select_field.select("Set schedule...")

      select "Anchored monthly", from: "ice_cube_select_frequency"

      expect(page).to have_css(".anchored_options", visible: true)

      within(".anchored_options") do
        # Defaults: 1st, Saturday, offsets 1, 3, 5, 8 selected
        expect(page).to have_css(".anchored_offsets a.selected", count: 4)

        find(".anchored_ordinal option", text: "2nd", exact_text: true).select_option
        find(".anchored_weekday option", text: "Tuesday", exact_text: true).select_option

        # Deselect two of the defaults, add a new one
        find(".anchored_offsets a", text: "1", exact_text: true).click
        find(".anchored_offsets a", text: "3", exact_text: true).click
        find(".anchored_offsets a", text: "10", exact_text: true).click
      end

      expect(page).to have_content("day offsets")

      click_button "OK"

      expect(page).not_to have_css(".ice_cube_select_dialog_holder")

      saved_value = select_field.value
      expect(saved_value).to include('"rule_type":"IceCube::AnchoredMonthlyRule"')
      expect(saved_value).to include('"anchor_ordinal":2')
      expect(saved_value).to include('"anchor_weekday":2')
      expect(saved_value).to include('"day_offsets":[5,8,10]')

      # Reopen and confirm the anchored pattern round-trips
      select_field.select("Set schedule...")

      expect(page).to have_css(".ice_cube_select_dialog_holder")
      expect(page).to have_select("ice_cube_select_frequency", selected: "Anchored monthly")
      expect(page).to have_css(".anchored_options", visible: true)

      within(".anchored_options") do
        expect(find(".anchored_ordinal").value).to eq("2")
        expect(find(".anchored_weekday").value).to eq("2")
        expect(page).to have_css(".anchored_offsets a.selected", count: 3)
        %w[5 8 10].each do |offset|
          expect(find(".anchored_offsets a", text: offset, exact_text: true)[:class]).to include("selected")
        end
      end
    end
  end
end
