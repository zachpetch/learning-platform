require "test_helper"

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
  end

  test "should show school" do
    get school_url(@school)
    assert_response :success
  end
end
