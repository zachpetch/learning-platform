require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  test "should create valid subscription" do
    subscription = Subscription.new(
      user: users(:four),
      term: terms(:one),
      status: :active
    )
    assert subscription.valid?
  end

  test "should require user" do
    subscription = Subscription.new(
      term: terms(:one),
      license: licenses(:one),
      status: :active
    )
    assert_not subscription.valid?
    assert_includes subscription.errors[:user], "must exist"
  end

  test "should require term" do
    subscription = Subscription.new(
      user: users(:one),
      license: licenses(:one),
      status: :active
    )
    assert_not subscription.valid?
    assert_includes subscription.errors[:term], "must exist"
  end

  test "should belong to user" do
    subscription = subscriptions(:one)
    assert_equal users(:one), subscription.user
  end

  test "should belong to term" do
    subscription = subscriptions(:one)
    assert_equal terms(:one), subscription.term
  end

  test "should have unique user per term" do
    Subscription.create!(
      user: users(:two),
      term: terms(:one),
      license: licenses(:one),
      status: :active
    )

    duplicate = Subscription.new(
      user: users(:two),
      term: terms(:one),
      license: licenses(:two),
      status: :active
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end

  test "should allow same user for different terms" do
    Subscription.create!(
      user: users(:three),
      term: terms(:one),
      license: licenses(:one),
      status: :active
    )

    different_term = Subscription.new(
      user: users(:three),
      term: terms(:two),
      license: licenses(:two),
      status: :active
    )
    assert different_term.valid?
  end

  test "should validate status enum values" do
    valid_statuses = [ :active, :expired, :cancelled ]

    valid_statuses.each do |status|
      subscription = Subscription.new(
        user: users(:five),
        term: terms(:one),
        license: licenses(:one),
        status: status
      )
      assert subscription.valid?, "Status #{status} should be valid"
    end
  end
end
