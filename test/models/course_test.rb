require "test_helper"

class CourseTest < ActiveSupport::TestCase
  test "should create valid course" do
    course = Course.new(
      school: schools(:one),
      subject: "Physics",
      number: 101,
      name: "Introduction to Physics"
    )
    assert course.valid?
  end

  test "should require school" do
    course = Course.new(
      subject: "Physics",
      number: 101,
      name: "Introduction to Physics"
    )
    assert_not course.valid?
    assert_includes course.errors[:school], "must exist"
  end

  test "should require subject" do
    course = Course.new(
      school: schools(:one),
      number: 101,
      name: "Introduction to Physics"
    )
    assert_not course.valid?
    assert_includes course.errors[:subject], "can't be blank"
  end

  test "should require number" do
    course = Course.new(
      school: schools(:one),
      subject: "Physics",
      name: "Introduction to Physics"
    )
    assert_not course.valid?
    assert_includes course.errors[:number], "can't be blank"
  end

  test "should require positive number" do
    course = Course.new(
      school: schools(:one),
      subject: "Physics",
      number: -1,
      name: "Introduction to Physics"
    )
    assert_not course.valid?
    assert_includes course.errors[:number], "must be greater than 0"
  end

  test "should belong to school" do
    course = courses(:one)
    assert_equal schools(:one), course.school
  end

  test "should have many course_offerings" do
    course = courses(:one)
    assert_respond_to course, :course_offerings
  end

  test "should have unique number per school and subject" do
    # Create first course
    Course.create!(
      school: schools(:one),
      subject: "Physics",
      number: 101,
      name: "Introduction to Physics"
    )

    # Try to create duplicate
    duplicate = Course.new(
      school: schools(:one),
      subject: "Physics",
      number: 101,
      name: "Advanced Physics"
    )
    assert_not duplicate.valid?
  end

  test "should allow same number for different schools" do
    Course.create!(
      school: schools(:one),
      subject: "Physics",
      number: 101,
      name: "Introduction to Physics"
    )

    # Same number, different school - should be valid
    different_school = Course.new(
      school: schools(:two),
      subject: "Physics",
      number: 101,
      name: "Introduction to Physics"
    )
    assert different_school.valid?
  end

  test "should allow same number for different subjects" do
    Course.create!(
      school: schools(:one),
      subject: "Physics",
      number: 101,
      name: "Introduction to Physics"
    )

    # Same number, different subject - should be valid
    different_subject = Course.new(
      school: schools(:one),
      subject: "Chemistry",
      number: 101,
      name: "Introduction to Chemistry"
    )
    assert different_subject.valid?
  end
end
