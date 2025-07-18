require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get dashboard_index_url
    assert_response :success
    assert_not_nil assigns(:schools)
    assert_not_nil assigns(:students)
  end

  test "should paginate schools correctly" do
    get dashboard_index_url, params: { schools_page: 2 }
    assert_response :success
    assert_not_nil assigns(:schools)
  end

  test "should paginate students correctly" do
    get dashboard_index_url, params: { students_page: 2 }
    assert_response :success
    assert_not_nil assigns(:students)
  end

  test "should search schools by name" do
    get dashboard_index_url, params: { school_search: "UBC" }
    assert_response :success
    schools = assigns(:schools)
    assert schools.any? { |s| s.name.include?("UBC") || s.short_name.include?("UBC") }
  end

  test "should search students by first name" do
    get dashboard_index_url, params: { student_search: "One" }
    assert_response :success
    students = assigns(:students)
    assert students.any? { |s| s.first_name.include?("One") }
  end

  test "should search students by full name" do
    get dashboard_index_url, params: { student_search: "One Example" }
    assert_response :success
    students = assigns(:students)
    assert students.any? { |s| "#{s.first_name} #{s.last_name}".include?("One Example") }
  end

  test "should search students by email" do
    get dashboard_index_url, params: { student_search: "one@example.com" }
    assert_response :success
    students = assigns(:students)
    assert students.any? { |s| s.email_address.include?("one@example.com") }
  end

  test "should handle empty search queries" do
    get dashboard_index_url, params: { school_search: "", student_search: "" }
    assert_response :success
    assert_not_nil assigns(:schools)
    assert_not_nil assigns(:students)
  end

  test "should handle case insensitive searches" do
    get dashboard_index_url, params: { school_search: "ubc" }
    assert_response :success
    schools = assigns(:schools)
    assert schools.any? { |s| s.short_name.downcase.include?("ubc") }
  end

  test "should return no results for non-existent search" do
    get dashboard_index_url, params: { school_search: "NonExistentSchool" }
    assert_response :success
    schools = assigns(:schools)
    assert_empty schools
  end

  # AJAX tests
  test "should handle ajax school search" do
    get search_schools_ajax_dashboard_index_url, params: { school_search: "UBC" }, xhr: true
    assert_response :success
    assert_template partial: "_schools_grid"
  end

  test "should handle ajax student search" do
    get search_students_ajax_dashboard_index_url, params: { student_search: "One" }, xhr: true
    assert_response :success
    assert_template partial: "_students_grid"
  end

  test "should require authentication for dashboard" do
    sign_out @user
    get dashboard_index_url
    assert_redirected_to new_session_path
  end
end
