class Api::V1::UsersController < ApplicationController
  before_action :load_user, only: [:register, :login]

  def register
    if @user
      render json: { error: 'User already exists' }, status: :bad_request
    else
      @user = User.new(email: user_params[:email], password: user_params[:password])
      if @user.save
        payload = AuthService.generate_tokens_for(@user)
        render json: { token: payload[:access_token], refresh_token: payload[:refresh_token] }, status: :created
      else
        render json: { error: @user.errors.full_messages }, status: :bad_request
      end
    end
  end

  def login
    if @user && @user.authenticate(params[:password])
      payload = AuthService.generate_tokens_for(@user)
      render json: { token: payload[:access_token], refresh_token: payload[:refresh_token] }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def user_params
    params.permit(:email, :password)
  end

  private

  def load_user
    @user = User.find_by(email: user_params[:email])
  end
end