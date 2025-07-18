require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    post session_url, params: { email_address: @user.email_address, password: "password" }
    assert_response :redirect

    # Follow the redirect to verify we're logged in
    follow_redirect!
    assert_response :success

    # Verify we can access a protected page
    get dashboard_index_url
    assert_response :success
  end

  test "should not create session with invalid email" do
    post session_url, params: { email_address: "invalid@example.com", password: "password" }
    assert_redirected_to new_session_path
    assert_nil session[:user_id]
    assert_match /Try another email address or password/, flash[:alert]
  end

  test "should not create session with invalid password" do
    post session_url, params: { email_address: @user.email_address, password: "wrongpassword" }
    assert_redirected_to new_session_path
    assert_nil session[:user_id]
    assert_match /Try another email address or password/, flash[:alert]
  end

  test "should not create session with empty credentials" do
    post session_url, params: { email_address: "", password: "" }
    assert_redirected_to new_session_path
    assert_nil session[:user_id]
  end

  test "should destroy session" do
    sign_in @user
    delete session_url
    assert_redirected_to new_session_path
    assert_nil session[:user_id]
  end

  test "should permit only required parameters" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "password",
      malicious_param: "should_be_ignored"
    }
    # Should still work, ignoring unpermitted parameters
    assert_response :redirect

    # Follow the redirect to verify login was successful
    follow_redirect!
    assert_response :success

    # Verify we can access a protected page
    get dashboard_index_url
    assert_response :success
  end

  test "should handle SQL injection attempts" do
    post session_url, params: {
      email_address: "'; DROP TABLE users; --",
      password: "password"
    }
    assert_redirected_to new_session_path
    assert_nil session[:user_id]
  end
end
