class DeliveryNotesController < ApplicationController
  respond_to :json

  def create
    delivery_note = DeliveryNote.new(params[:delivery_note].merge(:delivery_order_id => params[:delivery_order_id]))
    if delivery_note.save
      redirect_to(delivery_order_delivery_notes_path(params[:delivery_order_id], :format => :json))
    else
      head :status => :unprocessable_entity
    end
  end

  def index
    delivery_order = DeliveryOrder.find(params[:delivery_order_id])
    @notes = delivery_order.delivery_notes.order("created_at DESC")
    render :json => @notes.to_json(:only => [:content, :created_at])
  end
end