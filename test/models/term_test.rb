require "test_helper"

class TermTest < ActiveSupport::TestCase
  test "should create valid term" do
    term = Term.new(
      school: schools(:one),
      name: "Spring 2025",
      year: 2025,
      sequence_num: 1,
      start_date: Date.new(2025, 1, 15),
      end_date: Date.new(2025, 4, 15)
    )
    assert term.valid?
  end

  test "should require school" do
    term = Term.new(
      name: "Spring 2025",
      year: 2025,
      sequence_num: 1,
      start_date: Date.new(2025, 1, 15),
      end_date: Date.new(2025, 4, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:school], "must exist"
  end

  test "should require name" do
    term = Term.new(
      school: schools(:one),
      year: 2025,
      sequence_num: 1,
      start_date: Date.new(2025, 1, 15),
      end_date: Date.new(2025, 4, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:name], "can't be blank"
  end

  test "should require year" do
    term = Term.new(
      school: schools(:one),
      name: "Spring 2025",
      sequence_num: 1,
      start_date: Date.new(2025, 1, 15),
      end_date: Date.new(2025, 4, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:year], "can't be blank"
  end

  test "should require sequence_num" do
    term = Term.new(
      school: schools(:one),
      name: "Spring 2025",
      year: 2025,
      start_date: Date.new(2025, 1, 15),
      end_date: Date.new(2025, 4, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:sequence_num], "can't be blank"
  end

  test "should require start_date" do
    term = Term.new(
      school: schools(:one),
      name: "Spring 2025",
      year: 2025,
      sequence_num: 1,
      end_date: Date.new(2025, 4, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:start_date], "can't be blank"
  end

  test "should require end_date" do
    term = Term.new(
      school: schools(:one),
      name: "Spring 2025",
      year: 2025,
      sequence_num: 1,
      start_date: Date.new(2025, 1, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:end_date], "can't be blank"
  end

  test "should validate end_date is after start_date" do
    term = Term.new(
      school: schools(:one),
      name: "Spring 2025",
      year: 2025,
      sequence_num: 1,
      start_date: Date.new(2025, 4, 15),
      end_date: Date.new(2025, 1, 15)
    )
    assert_not term.valid?
    assert_includes term.errors[:end_date], "must be after start date"
  end

  test "should have scope for current terms" do
    assert_respond_to Term, :current
  end

  test "should belong to school" do
    term = terms(:one)
    assert_equal schools(:one), term.school
  end

  test "should have many subscriptions" do
    term = terms(:one)
    assert_respond_to term, :subscriptions
  end

  test "should have many course_offerings" do
    term = terms(:one)
    assert_respond_to term, :course_offerings
  end
end
