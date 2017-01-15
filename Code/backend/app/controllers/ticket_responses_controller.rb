class TicketResponsesController < ApplicationController
  before_action :set_ticket
  before_action :set_ticket_response, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  before_action :check_ticket_access

  # GET /tickets/:ticket_id/ticket_responses
  # Responds with all the ticket responses to the given ticket, if
  # the currently logged in user has access to the ticket
  def index
    @ticket_responses = @ticket.ticket_responses

    render json: @ticket_responses
  end

  # GET /tickets/:ticket_id/ticket_responses/1
  # Responds with a json containing this ticket response's data,
  # if the curently logged in user has acces to the ticket
  def show
    render json: @ticket_response
  end

  # POST /tickets/:ticket_id/ticket_responses
  # Handles the creation of new ticket responses, the currently
  # logged in user must have access to the ticket, and the ticket
  # must be OPEN
  def create
    @ticket_response = TicketResponse.new(ticket_response_params)
    @ticket_response.author_id = current_user.id

    if @ticket_response.save
      location = ticket_ticket_response_url(@ticket, @ticket_response)
      render json: @ticket_response, status: :created, location: location
    else
      render json: @ticket_response.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tickets/:ticket_id/ticket_responses/1
  # Handles the deletion of a ticket response, and as this operation
  # is very sensitive, only an Admin can perform it
  def destroy
    case current_user
    when Admin then @ticket_response.destroy
    else render_admin_only
    end
  end

  private
  # Verifies if the currently logged in user has access to the 
  # specified ticket
  #
  # @return boolean
  def check_ticket_access
    case current_user
    when Customer
      if @ticket.author_id != current_user.id
        render_unauthorized
      end
    end
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  rescue ActiveRecord::RecordNotFound
    render :status => :not_found
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_ticket_response
    @ticket_response = TicketResponse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :status => :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def ticket_response_params
    params.require(:ticket_response).permit(:body, :ticket_id, :author_id)
  end
end
