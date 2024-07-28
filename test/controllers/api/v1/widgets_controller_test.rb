require "test_helper"

class Api::V1::WidgetsControllerTest < ActionDispatch::IntegrationTest
  test "returns widgets when authorized" do
    user = User.create(email: 'email@email.com', password: 'password')
    post api_v1_users_login_url, params: { email: user.email, password: 'password' }
    token = JSON.parse(response.body)['token']
    
    get api_v1_widgets_index_url, headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :success
    widgets = JSON.parse(response.body)
    assert_equal 3, widgets.size
    assert_equal 'Foo', widgets[0]['name']
    assert_equal 'Bar', widgets[1]['name']
    assert_equal 'Baz', widgets[2]['name']
  end

  test "returns unauthorized when not authorized" do
    get api_v1_widgets_index_url, headers: { 'Authorization' => "Bearer Invalid Token" }

    assert_response :unauthorized
  end
end
