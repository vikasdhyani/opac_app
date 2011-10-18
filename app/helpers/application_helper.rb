module ApplicationHelper
  def title
    base_title = "Strata Retail - Just Books Community Library Chain"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    sortdir = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :sortdir => sortdir, :page => nil), {:class => css_class}
  end

  def image_url(titleId)

    if titleId then
      title = Title.find_all_by_id(titleId)
      if title.blank? or title[0].username.nil? or title[0].username.blank? or !title[0].username.eql?('AMS')
        "http://justbooksclc.com/images#{titleId/10000}/titles#{titleId/10000}/#{titleId}.jpg"
      else
        "http://img.justbooksclc.com.s3.amazonaws.com/#{title[0].isbn}.jpg"
      end
    else
      "#"
    end
  end

  def default_image_url
    "http://justbooksclc.com/images/noimage.jpg"
  end

  def schedule_by_date_and_slot_path(delivery_date, slot)
    show_delivery_schedule_path(:delivery_date => delivery_date.strftime("%Y/%m/%d"), :slot_id => slot.id )
  end
end
