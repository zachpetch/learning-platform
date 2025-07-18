require "test_helper"

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @school = schools(:one)
    sign_in @user
  end

  test "should show school" do
    get school_url(@school)
    assert_response :success
    assert_not_nil assigns(:school)
  end

  test "should calculate subscription count correctly" do
    get school_url(@school)
    assert_response :success
    assert_not_nil assigns(:subscription_count)
    assert assigns(:subscription_count).is_a?(Integer)
  end

  test "should calculate course payment count correctly" do
    get school_url(@school)
    assert_response :success
    assert_not_nil assigns(:course_payment_count)
    assert assigns(:course_payment_count).is_a?(Integer)
  end

  test "should calculate total student count correctly" do
    get school_url(@school)
    assert_response :success
    assert_not_nil assigns(:total_student_count)
    assert assigns(:total_student_count).is_a?(Integer)
  end

  test "should handle school with no current term" do
    school_without_term = School.create!(name: "School with No Terms", short_name: "SNT")

    get school_url(school_without_term)
    assert_response :success
    assert_nil assigns(:current_term)
    assert_equal 0, assigns(:subscription_count)
    assert_equal 0, assigns(:course_payment_count)
    assert_equal 0, assigns(:total_student_count)
  end

  test "should require authentication" do
    sign_out @user
    get school_url(@school)
    assert_redirected_to new_session_path
  end
end
