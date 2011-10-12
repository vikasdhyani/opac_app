class DeliverySchedulesController < ApplicationController
  def index
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
    render :layout => false
  end
end
