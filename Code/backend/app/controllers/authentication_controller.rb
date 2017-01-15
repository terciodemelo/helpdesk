class AuthenticationController < ApplicationController
  before_action :authenticate_request!, only: [:ping]
  
  # POST /api/login
  # This action handles a POST request for login
  # if the user data is right it will respond the request
  # with an auth token and the user data as JSON
  def authenticate_user
    user = User.where(email: params[:email]).first
    if user.password == params[:password]
      render json: payload(user)
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end

  # GET /api/ping
  # This action is used just to check if the service is alive
  #
  def ping
    render json: {logged_in: true, user: current_user.id}
  end

  private 

  # This methods generates an authentication token and returns
  # it with a Hash containing basic user data
  #
  # @return [Hash] {auth_token, user: {id, email, type}}
  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email, type: user.type}
    }
  end
end
