class TicketResponsesController < ApplicationController
  before_action :set_ticket_response, only: [:show, :update, :destroy]

  # GET /ticket_responses
  def index
    @ticket_responses = TicketResponse.all

    render json: @ticket_responses
  end

  # GET /ticket_responses/1
  def show
    render json: @ticket_response
  end

  # POST /ticket_responses
  def create
    @ticket_response = TicketResponse.new(ticket_response_params)

    if @ticket_response.save
      render json: @ticket_response, status: :created, location: @ticket_response
    else
      render json: @ticket_response.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ticket_responses/1
  def update
    if @ticket_response.update(ticket_response_params)
      render json: @ticket_response
    else
      render json: @ticket_response.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ticket_responses/1
  def destroy
    @ticket_response.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_response
      @ticket_response = TicketResponse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_response_params
      params.require(:ticket_response).permit(:body, :ticket_id, :author_id)
    end
end
