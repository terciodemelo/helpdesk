class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /api/tickets
  # Responds with all the tickets that the currently logged in user
  # has access to. If this user is a SupportAgent or an Admin, they
  # have access to all tickets, but if it is a Customer, then it has
  # access to their own tickets
  def index
    @tickets = case current_user
               when Customer then Ticket.where(author_id: current_user.id)
               else Ticket.all
               end

    render json: @tickets
  end

  # GET /api/tickets/1
  # Responds with the details for the requested ticket if the
  # currently logged user is a SupportAgent or Admin, or they are
  # the ticket's author
  def show
    case current_user
    when Customer
      if @ticket.author_id == current_user.id
        render json: @ticket
      else
        render_unauthorized
      end
    else
      render json: @ticket
    end
  end

  # POST /api/tickets
  # Handles the creation of new tickets, but only Customers
  # are allowed to create new Tickets
  def create
    case current_user
    when Customer
      @ticket = Ticket.new(ticket_params)
      @ticket.author_id = current_user.id

      if @ticket.save
        render json: @ticket, status: :created, location: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /api/tickets/1
  # Handles the update of existing tickets. The currently logged
  # in user must be either the ticket's creator or a SupportAgent
  # or an Admin
  #
  # @see can_update_ticket?
  def update
    if can_update_ticket? @ticket
      if @ticket.update(ticket_params)
        render json: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # DELETE /api/tickets/1
  # Handles the deletion of existing tickets, only Admins are
  # allowed to do it
  def destroy
    case current_user
    when Admin
      @ticket.destroy
    else
      render_unauthorized
    end
  end

  private
  # For a given Ticket instance, verifies if the currently logged in
  # user is allowed to update the ticket
  #
  # @param [Ticket] ticket 
  # @return [boolean] 
  def can_update_ticket? ticket
    not current_user.is_a? Customer or current_user.id == ticket.author_id
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :status => :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def ticket_params
    params.require(:ticket).permit(:title, :body, :status, :author_id)
  end
end
