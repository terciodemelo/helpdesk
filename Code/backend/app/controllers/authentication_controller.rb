class AuthenticationController < ApplicationController
  before_action :authenticate_request!, only: [:ping]
  
  def authenticate_user
    user = User.where(email: params[:email]).first
    if user.password == params[:password]
      render json: payload(user)
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end

  def ping
    render json: {logged_in: true, user: current_user.id}
  end

  private 
  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email, type: user.type}
    }
  end
end
