task :testing_this => :environment do
    require 'anemone'
    rooter = 'chaudpatate.org'
    banned = ['tel:','@', '#', 'facebook.com', 'twitter.com', 'pinterest.com', 'linkedin.com', 'youtube.com','reddit.com', 'wikipedia.org']
    extensions = %w( .jpg .jpeg .png .doc .pdf .js .css .xml .csv. .exe .zip .gzip )
    start = Time.now
    Anemone.crawl("http://#{rooter}/", {:threads => 4, :discard_page_bodies => false, :obey_robots_txt => false, :user_agent => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'}) do |anemone|
        begin
  #         anemone.on_every_page do |page|
  # puts page.url.path
  # if page.doc.present?
  #   links = page.doc.xpath("//a/@href")



            anemone.on_every_page do |page|
                puts page.url.path
        if page.doc.present?
        links = page.doc.xpath("//a/@href")
        if (links != nil)
          links.each do |link|
            this_link = link.to_s
            unless extensions.any? { |exten| this_link && this_link.include?(exten) }
                unless banned.any? { |word| this_link && this_link.include?(word) }
                    unless this_link.include? rooter
                        # puts this_link
                        obl = URI.parse(URI.encode(this_link.strip)).host
                        unless obl.blank?
                            if obl.include? 'www.'
                                obl = obl.gsub("www.", "")
                            end
                            Obl.find_or_create_by(url: obl)
                        end
                    end
                  end
                end
              end
          end
        end
        end
    rescue OpenURI::HTTPError => ex
    puts ex
    end
    end
    time_t = Time.now - start
    puts "-------------"
    puts "#{time_t} seconds"
    puts "-------------"
end
