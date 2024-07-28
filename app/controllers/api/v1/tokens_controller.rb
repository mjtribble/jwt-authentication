class Api::V1::TokensController < ApplicationController
  def validate
    token = request.headers['Authorization']&.split(' ')&.last
    payload = AuthService.decode(token)
    user_id = payload&.dig('user_id')
    if user_id && User.find(user_id)
      render status: :ok
    else 
      render status: :unauthorized
    end
  end

  def refresh
    refresh_token = RefreshToken.find_by(secret: params[:refresh_token])

    if refresh_token&.expired? || refresh_token&.revoked?
      render status: :unauthorized
    else
      new_access_token = AuthService.generate_access_token(refresh_token.user)
      render json: { access_token: new_access_token, refresh_token: params[:refresh_token] }
    end
  end
  
  private
  
  def token_params
    params.permit(:token, :refresh_token)
  end
end
