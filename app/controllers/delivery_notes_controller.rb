class DeliveryNotesController < ApplicationController
  def create
    delivery_note = DeliveryNote.new(params[:delivery_note].merge(:delivery_order_id => params[:delivery_order_id]))
    if delivery_note.save
      head :status => :created
    else
      head :status => :unprocessable_entity
    end
  end

  def index
    @notes = DeliveryNote.where(:delivery_order_id => params[:delivery_order_id]).order("created_at DESC")
    render :partial => "index"
  end
end