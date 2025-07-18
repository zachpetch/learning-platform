require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "should redirect to login when not authenticated" do
    get dashboard_index_url
    assert_redirected_to new_session_path
  end

  test "should allow access when authenticated" do
    sign_in users(:one)
    get dashboard_index_url
    assert_response :success
  end

  test "should maintain session across requests" do
    user = users(:one)
    sign_in user

    get dashboard_index_url
    assert_response :success

    get school_url(schools(:one))
    assert_response :success

    get user_url(user)
    assert_response :success
  end

  test "should clear session on logout" do
    user = users(:one)
    sign_in user

    get dashboard_index_url
    assert_response :success

    delete session_url
    assert_redirected_to new_session_path

    get dashboard_index_url
    assert_redirected_to new_session_path
  end
end
