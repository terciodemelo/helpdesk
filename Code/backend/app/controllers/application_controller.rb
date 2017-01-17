class ApplicationController < ActionController::API
  attr_reader :current_user
  
  # This is an action guard that responds an unauthorized
  # message if the request is not authenticated, i.e.,
  # there's no user logged in
  def authenticate_request!
    unless user_id_in_token?
      return render_unauthorized
    end

    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render_unauthorized_wrong_token
  end

  # Verifies if the current request being made is authenticated
  #
  # @return [boolean] true if authenticated, false otherwise
  def authenticated_request?
    @current_user = nil
    @current_user = User.where(id: auth_token[:user_id]).first if user_id_in_token?
    not current_user.nil?
  end

  # Verifies if the current logged in user is an Admin
  #
  # @return [boolean] true if current user is admin, false othewise
  def logged_in_as_admin?
    not current_user.nil? and current_user.is_a? Admin
  end


  # Responds request an unauthorized status, json content-type,
  # and a message explaining that the current action is for
  # administrators only
  def render_admin_only
    render_unauthorized(msg="You must be Admin to perform this operation")
  end

  # Responds request a not fonud status, json content-type,
  # and a message explaining that the requested resource
  # does not exist
  #
  # @param [String] msg a message to be responded
  def render_not_found(msg="Resource Not Found")
    render json: { errors: [msg] }, status: :not_found
  end

  # Responds request an unauthorized status, json content-type,
  # and a message explaining that they do not have authorization
  # to perform the current action
  #
  # @param [String] msg a message to be responded
  def render_unauthorized(msg="Not Authenticated")
    render json: { errors: [msg] }, status: :unauthorized
  end

  # Responds request an unauthorized status, json content-type,
  # and a message explaining that they do not have authorization
  # to perform the current action
  #
  # @param [String] msg a message to be responded
  def render_unauthorized_wrong_token
    render json: { errors: [msg] }, status: :unauthorized
  end

  private

  # Extracts the authorization token from the 'Authorization' field
  # in a request headers, then it saves it in @http_token and returns
  # it
  #
  # @return [String] the request authorization token, if any
  def http_token
    @http_token ||= if request.headers['Authorization'].present?
                      request.headers['Authorization'].split.last
                    end
  end

  # It makes use of JsonWebToken#decode to decode the authorization
  # token provided in a request headers.
  #
  # @see #http_token
  # @see JsonWebToken#decode
  # @return [Hash] A hash containing the authentication data
  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  # It verifies if the authentication data contains the user_id
  #
  # @return [boolean]
  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end
