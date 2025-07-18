require "application_system_test_case"

class SchoolsTest < ApplicationSystemTestCase
  setup do
    @school = schools(:one)
  end

  # test "visiting the index" do
  #   visit school_url
  #   assert_selector "h1", text: "Schools"
  # end
  #
  # test "should create school" do
  #   visit school_url
  #   click_on "New school"
  #
  #   fill_in "Name", with: @school.name
  #   fill_in "Short name", with: @school.short_name
  #   click_on "Create School"
  #
  #   assert_text "School was successfully created"
  #   click_on "Back"
  # end
  #
  # test "should update School" do
  #   visit school_url(@school)
  #   click_on "Edit this school", match: :first
  #
  #   fill_in "Name", with: @school.name
  #   fill_in "Short name", with: @school.short_name
  #   click_on "Update School"
  #
  #   assert_text "School was successfully updated"
  #   click_on "Back"
  # end
  #
  # test "should destroy School" do
  #   visit school_url(@school)
  #   click_on "Destroy this school", match: :first
  #
  #   assert_text "School was successfully destroyed"
  # end
end
