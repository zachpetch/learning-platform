require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "should create valid payment for course offering" do
    payment = Payment.new(
      user: users(:one),
      course_offering: course_offerings(:one),
      amount: 25000,
      provider: "Credit Card",
      provider_transaction_id: "TEST-123",
      completed_at: Time.current
    )
    assert payment.valid?
  end

  test "should create valid payment for subscription" do
    payment = Payment.new(
      user: users(:one),
      subscription: subscriptions(:one),
      amount: 35000,
      provider: "Credit Card",
      provider_transaction_id: "TEST-456",
      completed_at: Time.current
    )
    assert payment.valid?
  end

  test "should require user" do
    payment = Payment.new(
      course_offering: course_offerings(:one),
      amount: 25000,
      provider: "Credit Card",
      provider_transaction_id: "TEST-123"
    )
    assert_not payment.valid?
    assert_includes payment.errors[:user], "must exist"
  end

  test "should require amount" do
    payment = Payment.new(
      user: users(:one),
      course_offering: course_offerings(:one),
      provider: "Credit Card",
      provider_transaction_id: "TEST-123"
    )
    assert_not payment.valid?
    assert_includes payment.errors[:amount], "can't be blank"
  end

  test "should require positive amount" do
    payment = Payment.new(
      user: users(:one),
      course_offering: course_offerings(:one),
      amount: -100,
      provider: "Credit Card",
      provider_transaction_id: "TEST-123"
    )
    assert_not payment.valid?
    assert_includes payment.errors[:amount], "must be greater than 0"
  end

  test "should require provider" do
    payment = Payment.new(
      user: users(:one),
      course_offering: course_offerings(:one),
      amount: 25000,
      provider_transaction_id: "TEST-123"
    )
    assert_not payment.valid?
    assert_includes payment.errors[:provider], "can't be blank"
  end

  test "should require provider_transaction_id" do
    payment = Payment.new(
      user: users(:one),
      course_offering: course_offerings(:one),
      amount: 25000,
      provider: "Credit Card"
    )
    assert_not payment.valid?
    assert_includes payment.errors[:provider_transaction_id], "can't be blank"
  end

  test "should require either course_offering or subscription" do
    payment = Payment.new(
      user: users(:one),
      amount: 25000,
      provider: "Credit Card",
      provider_transaction_id: "TEST-123"
    )
    assert_not payment.valid?
  end

  test "should not allow both course_offering and subscription" do
    payment = Payment.new(
      user: users(:one),
      course_offering: course_offerings(:one),
      subscription: subscriptions(:one),
      amount: 25000,
      provider: "Credit Card",
      provider_transaction_id: "TEST-123"
    )
    assert_not payment.valid?
  end

  test "should have scope for completed payments" do
    assert_respond_to Payment, :completed
  end

  test "should have scope for refunded payments" do
    assert_respond_to Payment, :refunded
  end
end
