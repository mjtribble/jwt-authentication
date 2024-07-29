require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should register user" do
    post api_v1_users_register_url, params: {email: "test@test.com", password: "password"}
    assert_response :created
    assert JSON.parse(response.body).key?("token")
    assert JSON.parse(response.body).key?("refresh_token")
  end

  test "should not register user if already exists" do
    User.create(email: "email@email.com", password: "password")
    post api_v1_users_register_url, params: {email: "email@email.com", password: "password"}
    assert_response :bad_request
  end

  test "should login user" do
    user = User.create(email: "email@email.com", password: "password")
    post api_v1_users_login_url, params: {email: user.email, password: "password"}
    assert_response :ok
    assert JSON.parse(response.body).key?("token")
    assert JSON.parse(response.body).key?("refresh_token")
  end

  test "should not login user if invalid email or password" do
    user = User.create(email: "email@email.com", password: "password")
    post api_v1_users_login_url, params: {email: user.email, password: "wrong_password"}
    assert_response :unauthorized
  end
end
