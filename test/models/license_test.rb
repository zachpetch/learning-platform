require "test_helper"

class LicenseTest < ActiveSupport::TestCase
  test "should create valid license" do
    license = License.new(
      code: "1234-5678-9012-3456",
      term_count: 1
    )
    assert license.valid?
  end

  test "should require code" do
    license = License.new(term_count: 1)
    assert_not license.valid?
    assert_includes license.errors[:code], "can't be blank"
  end

  test "should require positive term_count" do
    license = License.new(
      code: "1234-5678-9012-3456",
      term_count: 0
    )
    assert_not license.valid?
    assert_includes license.errors[:term_count], "must be greater than 0"
  end

  test "should require non-negative term_count" do
    license = License.new(
      code: "1234-5678-9012-3456",
      term_count: -1
    )
    assert_not license.valid?
    assert_includes license.errors[:term_count], "must be greater than 0"
  end

  test "should have unique code" do
    License.create!(code: "1234-5678-9012-3456", term_count: 1)

    duplicate = License.new(code: "1234-5678-9012-3456", term_count: 2)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:code], "has already been taken"
  end

  test "should have many subscriptions" do
    license = licenses(:one)
    assert_respond_to license, :subscriptions
  end
end
