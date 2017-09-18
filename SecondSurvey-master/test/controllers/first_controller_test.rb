require 'test_helper'

class FirstControllerTest < ActionDispatch::IntegrationTest
  test "should get get_page" do
    get first_get_page_url
    assert_response :success
  end

end
