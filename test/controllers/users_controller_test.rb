require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:two)
    sign_in @user
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
    assert_not_nil assigns(:user)
    assert_equal @user, assigns(:user)
  end

  test "should show other user" do
    get user_url(@other_user)
    assert_response :success
    assert_not_nil assigns(:user)
    assert_equal @other_user, assigns(:user)
  end

  # test "should handle non-existent user" do
  #   assert_raises(ActiveRecord::RecordNotFound) do
  #     get user_url(id: 999999)
  #   end
  # end

  test "should require authentication" do
    sign_out @user
    get user_url(@user)
    assert_redirected_to new_session_path
  end
end
