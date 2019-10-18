require 'test_helper'

class BasicLayoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get basic_layouts_home_url
    assert_response :success
  end

end
