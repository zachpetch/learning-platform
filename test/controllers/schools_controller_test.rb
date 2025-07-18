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
    assert_not_nil assigns(:total_subscriptions_count)
    assert assigns(:total_subscriptions_count).is_a?(Integer)
  end

  test "should calculate course payment count correctly" do
    get school_url(@school)
    assert_response :success
    assert_not_nil assigns(:total_course_offering_count)
    assert assigns(:total_course_offering_count).is_a?(Integer)
  end

  test "should calculate total student count correctly" do
    get school_url(@school)
    assert_response :success
    assert_not_nil assigns(:total_student_count)
    assert assigns(:total_student_count).is_a?(Integer)
  end

  test "should handle school with no current terms but has past terms" do
    school = School.create!(name: "School with Past Terms", short_name: "SPT")

    past_term = school.terms.create!(
      name: "Fall 2023",
      year: 2023,
      sequence_num: 2,
      start_date: 6.months.ago,
      end_date: 3.months.ago
    )

    get school_url(school)
    assert_response :success

    assert_equal [], assigns(:current_terms)
    assert_not_equal [], assigns(:past_terms)
    assert_equal 1, assigns(:past_terms).count

    assert_equal 0, assigns(:current_subscriptions_count)
    assert_equal 0, assigns(:current_course_offering_count)
  end

  test "should handle school with no terms" do
    school_without_terms = School.create!(name: "Empty School", short_name: "ES")

    get school_url(school_without_terms)
    assert_response :success

    assert_equal [], assigns(:past_terms)
    assert_equal [], assigns(:current_terms)
    assert_equal [], assigns(:upcoming_terms)

    assert_equal 0, assigns(:total_subscriptions_count)
    assert_equal 0, assigns(:total_course_offering_count)
    assert_equal 0, assigns(:total_student_count)
  end

  test "should handle school with terms but no subscriptions or payments" do
    school = School.create!(name: "School with Empty Terms", short_name: "SET")

    # Create current term but no subscriptions or payments
    current_term = school.terms.create!(
      name: "Spring 2025",
      year: 2025,
      sequence_num: 0,
      start_date: 1.month.ago,
      end_date: 2.months.from_now
    )

    get school_url(school)
    assert_response :success

    # Should have current terms but zero counts
    assert_equal 1, assigns(:current_terms).count
    assert_equal 0, assigns(:current_subscriptions_count)
    assert_equal 0, assigns(:current_course_offering_count)
    assert_equal 0, assigns(:total_student_count)
  end

  test "should require authentication" do
    sign_out @user
    get school_url(@school)
    assert_redirected_to new_session_path
  end
end
