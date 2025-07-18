require "test_helper"

class CourseOfferingTest < ActiveSupport::TestCase
  test "should create valid course offering" do
    course_offering = CourseOffering.new(
      course: courses(:one),
      term: terms(:two)
    )
    assert course_offering.valid?
  end

  test "should require course" do
    course_offering = CourseOffering.new(term: terms(:one))
    assert_not course_offering.valid?
    assert_includes course_offering.errors[:course], "must exist"
  end

  test "should require term" do
    course_offering = CourseOffering.new(course: courses(:one))
    assert_not course_offering.valid?
    assert_includes course_offering.errors[:term], "must exist"
  end

  test "should belong to course" do
    course_offering = course_offerings(:one)
    assert_equal courses(:one), course_offering.course
  end

  test "should belong to term" do
    course_offering = course_offerings(:one)
    assert_equal terms(:one), course_offering.term
  end

  test "should have payments" do
    course_offering = course_offerings(:one)
    assert_respond_to course_offering, :payments
  end

  test "should have unique course per term" do
    # Create first course offering
    CourseOffering.create!(course: courses(:two), term: terms(:one))

    # Try to create duplicate
    duplicate = CourseOffering.new(course: courses(:two), term: terms(:one))
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:course_id], "has already been taken"
  end
end
