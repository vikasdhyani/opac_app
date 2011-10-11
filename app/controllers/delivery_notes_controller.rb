class DeliveryNotesController < ApplicationController
  def create
    delivery_note = DeliveryNote.new(params[:delivery_note].merge(:delivery_order_id => params[:delivery_order_id]))
    if delivery_note.save
      redirect_to(delivery_order_delivery_notes_path(params[:delivery_order_id]))
    else
      head :status => :unprocessable_entity
    end
  end

  def index
    @delivery_order = DeliveryOrder.find(params[:delivery_order_id])
    @notes = @delivery_order.delivery_notes.order("created_at DESC")
    render :partial => "index"
  end

end