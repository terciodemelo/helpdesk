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

  def authenticated_request?
    @current_user = nil
    @current_user = User.where(id: auth_token[:user_id]).first if user_id_in_token?
    not current_user.nil?
  end

  def logged_in_as_admin?
    not current_user.nil? and current_user.is_a? Admin
  end

  def render_admin_only
    render_unauthorized(msg="You must be Admin to perform this operation")
  end

  def render_unauthorized(msg="Not Authenticated")
    render json: { errors: [msg] }, status: :unauthorized
  end

  private

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
