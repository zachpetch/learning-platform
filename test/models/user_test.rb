require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create valid user" do
    user = User.new(
      email_address: "test@example.com",
      password: "password",
      first_name: "Test",
      last_name: "User"
    )
    assert user.valid?
  end

  test "should require email_address" do
    user = User.new(password: "password", first_name: "Test", last_name: "User")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should require unique email_address" do
    User.create!(
      email_address: "test@example.com",
      password: "password",
      first_name: "Test",
      last_name: "User"
    )

    duplicate = User.new(
      email_address: "test@example.com",
      password: "password",
      first_name: "Test2",
      last_name: "User2"
    )
    assert_not duplicate.valid?
  end

  test "should require password" do
    user = User.new(email_address: "test@example.com", first_name: "Test", last_name: "User")
    assert_not user.valid?
  end

  test "should require first_name" do
    user = User.new(email_address: "test@example.com", password: "password", last_name: "User")
    assert_not user.valid?
    assert_includes user.errors[:first_name], "can't be blank"
  end

  test "should require last_name" do
    user = User.new(email_address: "test@example.com", password: "password", first_name: "Test")
    assert_not user.valid?
    assert_includes user.errors[:last_name], "can't be blank"
  end

  test "should authenticate with correct password" do
    user = users(:one)
    assert_equal user, User.authenticate_by(email_address: user.email_address, password: "password")
  end

  test "should not authenticate with wrong password" do
    user = users(:one)
    assert_nil User.authenticate_by(email_address: user.email_address, password: "wrongpassword")
  end

  test "should have many subscriptions" do
    user = users(:one)
    assert_respond_to user, :subscriptions
  end

  test "should have many payments" do
    user = users(:one)
    assert_respond_to user, :payments
  end

  test "should normalize email address" do
    user = User.create!(
      email_address: "  Test@ExAmple.COM  ",
      password: "password",
      first_name: "Test",
      last_name: "User"
    )
    assert_equal "test@example.com", user.email_address
  end
end
