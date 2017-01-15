class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /tickets
  def index
    @tickets = case current_user
               when Customer then Ticket.where(author_id: current_user.id)
               else Ticket.all
               end

    render json: @tickets
  end

  # GET /tickets/1
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

  # POST /tickets
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

  # PATCH/PUT /tickets/1
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

  # DELETE /tickets/1
  def destroy
    case current_user
    when Admin
      @ticket.destroy
    else
      render_unauthorized
    end
  end

  private
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
