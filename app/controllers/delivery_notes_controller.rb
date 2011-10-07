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
    @notes = DeliveryNote.where(:delivery_order_id => params[:delivery_order_id]).order("created_at DESC")
    @delivery_order_id = params[:delivery_order_id]
    render :partial => "index"
  end
end