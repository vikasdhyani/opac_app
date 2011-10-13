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
    render :json => {
      :id => delivery_order.id,
#      :title => delivery_order.title.title,
      :membership_no => delivery_order.membership_no,
      :delivery_notes => delivery_order.delivery_notes.order("created_at DESC").collect{ |note| {
        :created_date => note.created_at.strftime("%d %b %Y"),
        :content => note.content,
      }},
    }
  end
end