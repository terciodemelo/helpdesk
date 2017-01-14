class ApplicationController < ActionController::API
  attr_reader :current_user
  
  protected
  def authenticate_request!
    unless user_id_in_token?
      return render_unauthorized
    end

    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render_unauthorized
  end

  private
  def render_unauthorized
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
                      request.headers['Authorization'].split.last
                    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end
