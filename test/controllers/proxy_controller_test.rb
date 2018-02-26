require 'test_helper'

class ProxyControllerTest < ActionDispatch::IntegrationTest
  test "should get modify" do
    get proxy_modify_url
    assert_response :success
  end

end
