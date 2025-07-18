require "test_helper"

class SchoolTest < ActiveSupport::TestCase
  test "should create valid school" do
    school = School.new(name: "Test University", short_name: "TU")
    assert school.valid?
  end

  test "should require name" do
    school = School.new(short_name: "TU")
    assert_not school.valid?
    assert_includes school.errors[:name], "can't be blank"
  end

  test "should require short_name" do
    school = School.new(name: "Test University")
    assert_not school.valid?
    assert_includes school.errors[:short_name], "can't be blank"
  end

  test "should have terms" do
    school = schools(:one)
    assert_respond_to school, :terms
  end

  test "should have courses" do
    school = schools(:one)
    assert_respond_to school, :courses
  end
end
