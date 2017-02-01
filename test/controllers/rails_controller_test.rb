require 'test_helper'

class RailsControllerTest < ActionDispatch::IntegrationTest
  test "should get generate" do
    get rails_generate_url
    assert_response :success
  end

  test "should get controller" do
    get rails_controller_url
    assert_response :success
  end

  test "should get schools" do
    get rails_schools_url
    assert_response :success
  end

end
