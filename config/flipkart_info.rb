class FlipkartInfo
  class << self

    def book_info(isbn)
      url = "http://www.flipkart.com/search.php?query=#{isbn}"
      page = Mechanize.new.get(url)

      title = nil
      authors = nil
      publisher = nil
      pubdate = nil
      binding = nil
      page_cnt = nil
      language = nil
      awards = nil
      summary = nil

      product_details = page.search("div#details table.fk-specs-type1 tr")
      if product_details.length != 0
        product_details.each do |product_detail|
          next if product_detail.children.empty?
          key = product_detail.children[0].text.strip.encode('UTF-8').gsub(":", "")
          value = product_detail.children[1].text.strip.encode('UTF-8')
          case key
          when "Book"
            title = value
          when "Author"
            authors = value
          when "Publisher"
            publisher = value
          when "Publishing Date"
            pubdate = value
          when "Binding"
            binding = value
          when "Number of Pages"
            page_cnt = value
          when "Language"
            language = value
          when "Awards"
            awards = value
          end
        end
      else
        return nil
      end

      image = nil
      image_tag = page.search("div#mprodimg-id img")
      unless image_tag.nil?
        image = image_tag.attr('src').text.encode('UTF-8')
      end

      summary_detail = page.search("div.item_desc_text.description")
      if summary_detail.length != 0 
        summary = summary_detail.inner_text.strip.encode('UTF-8')
      end

      {
        :info_source => "flipkart",
        :title => title,
        :authors => authors,
        :publisher => publisher,
        :image => image,
        :pubdate => pubdate,
        :format => binding,
        :page_cnt => page_cnt,
        :language => language
      }
    end

  end
end
