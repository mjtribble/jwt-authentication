class Api::V1::ApiController < ApplicationController
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    payload = AuthService.decode(token)
    @current_user = User.find_by(id: payload&.dig("user_id")) if payload&.dig("user_id")
    render status: :unauthorized unless @current_user
  end
end