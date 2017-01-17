class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :tickets]
  before_action :authenticate_request!, except: [:create]

  # 
  # Responds with a JSON containing data regarding to all
  # existing users in the system
  #
  def index
    @users = User.all

    render json: @users
  end

  #
  # Respondsall the tickets the specified user has
  #
  def tickets
    render json: @user.tickets
  end

  # 
  # Respondse with a JSON containing data regarding to the
  # specified user 
  #
  def show
    render json: @user
  end

  # Creates a new user with the following restrictions:
  #   * Only admins and Unauthenticated users can create new users
  #   * Unauthenticated users can create only Customers
  #
  def create
    @user = User.new(user_params)

    if authenticated_request?
      return render_admin_only unless logged_in_as_admin?
    elsif not @user.is_a? Customer
      return render_unauthorized
    end

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
	rescue ActiveRecord::RecordNotUnique
		render json: @user.attributes.slice("email"), status: :conflict
  end

  # 
  # Updates an existing users with the following restrictions
  #   * Admins can update any user
  #   * Except for admins, everybody else can update only their
  #     own data
  #
  def update
		if not self_reference_or_admin?
			render_unauthorized
    elsif @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # 
  # Deletes an existing users with the following restrictions
  #   * Admins can delete any user
  #   * Except for admins, nobody else can delete a user
  #
  def destroy
		if not is_admin?
			render_admin_only
		else
			@user.destroy
		end
  end

  private
		#
		# Verifies if the currently logged in user is an Admin or
		# if the user referenced by the route is themself
		#
		# @return [boolean]
		def self_reference_or_admin?
			is_admin? or current_user.id == set_user.id
		end

		#
		# Verifies if the currently logged in user is an Admin
		#
		# @return [boolean]
		def is_admin?
			not current_user.nil? and current_user.is_a? Admin
		end
	
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @user = User.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :type, :email, :password)
    end
end
