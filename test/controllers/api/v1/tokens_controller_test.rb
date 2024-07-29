require "test_helper"
class Api::V1::TokensControllerTest < ActionDispatch::IntegrationTest
  test "should validate token" do
    user = User.create(email: "email@email.com", password: "password")
    post api_v1_users_login_url, params: {email: user.email, password: "password"}
    token = JSON.parse(response.body)["token"]
    post api_v1_tokens_validate_url, headers: {"Authorization" => "Bearer #{token}"}

    assert_response :ok
  end

  test "should not validate token if invalid" do
    post api_v1_tokens_validate_url, headers: {"Authorization" => "Bearer invalid_token"}
    assert_response :unauthorized
  end

  test "should not validate token if expired" do
    user = User.create(email: "email@email.com", password: "password")
    post api_v1_users_login_url, params: {email: user.email, password: "password"}
    token = JSON.parse(response.body)["access_token"]

    travel_to 1.hour.from_now
    post api_v1_tokens_validate_url, headers: {"Authorization" => "Bearer #{token}"}
    assert_response :unauthorized
    travel_back
  end

  test "should return new access token" do
    user = User.create(email: "email@email.com", password: "password")
    post api_v1_users_login_url, params: {email: user.email, password: "password"}
    refresh_token = JSON.parse(response.body)["refresh_token"]
    access_token = JSON.parse(response.body)["token"]
    post api_v1_tokens_refresh_url, params: {refresh_token: refresh_token}

    assert_response :ok
    assert_not_equal access_token, JSON.parse(response.body)["access_token"]
    assert_equal refresh_token, JSON.parse(response.body)["refresh_token"]
  end

  test "should not return new access token if refresh_token is expired" do
    user = User.create(email: "email@email.com", password: "password")
    post api_v1_users_login_url, params: {email: user.email, password: "password"}
    refresh_token = JSON.parse(response.body)["refresh_token"]
    travel_to 25.hours.from_now
    post api_v1_tokens_refresh_url, params: {refresh_token: refresh_token}
    assert_response :unauthorized
    travel_back
  end
end
