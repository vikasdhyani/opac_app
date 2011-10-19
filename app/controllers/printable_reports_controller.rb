class PrintableReportsController < ApplicationController
  def show
    @printable_report_presenter = PrintableReportPresenter.new(params[:delivery_date])
    render :layout => false
  end
end
