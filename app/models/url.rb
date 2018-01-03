# require 'anemone'
# require 'mongo'

# # MongoDB setup
# db = Mongo::Connection.new.db("demo")
# urls_collection = db["page_urls"]

# #New Anemone web crawler setup and main operation
# Anemone.crawl("http://www.fondazionecollegiopiox.org") do |anemone|
#   anemone.storage = Anemone::Storage.MongoDB
#   anemone.on_every_page do |page|

#     puts page.code.to_s + ": " + page.url.to_s

#     if page.code && page.url
#       url = {code: page.code, url: page.url.to_s}
#       puts "Inserting #{url.inspect}"
#       urls_collection.insert url
#     end
#   end
# end




require 'rubygems'
require 'anemone'
require 'mongo'
require 'json'
require 'mongo'
include Mongo


$stdout = File.new('sitemap.json','w')


Anemone.crawl("http://chaudpatate.org/") do |anemone|
  anemone.storage = Anemone::Storage.MongoDB
  anemone.on_every_page do |page|
      puts page.url
  end
end


# Anemone.crawl(domain, :depth_limit => 1) do | anemone |
#   anemone.storage = Anemone::Storage.MongoDB
#   anemone.on_every_page do |page|
#       puts page.url
#       puts page.depth

#   end
# end


# Anemone.crawl("http://www.reinteractive.net/blog", :verbose => false, :depth_limit => 5) do |anemone|
#   anemone.focus_crawl do |page|
#     page.links.select{|link| link.to_s.match(BLOG_NAVIGATION_URLS) || link.to_s.match(BLOG_POST_URLS)}
#   end
#   anemone.on_every_page do |page|
#     process_blog_post(page) if page.code == 200 && page.url.to_s.match(BLOG_POST_URLS)
#   end
# end






# #!/usr/bin/env ruby
# require 'anemone'
# require 'nokogiri'
# require 'net/http'

# require 'data_mapper'
# require 'dm-sqlite-adapter'

# class Url
#   include DataMapper::Resource

#   property  :id,          Serial
#   property  :url,         Text,       :required=>true
#   property  :code,        Integer
#   property  :redirect,    Text
#   property  :depth,       Integer
#   property  :forms,       String,     :length => 256
#   property  :created_at,  DateTime,   :default=>DateTime.now
#   property  :updated_at,  DateTime,   :default=>DateTime.now

# end

# def read_http(url)
#  uri = URI(url)
#  Net::HTTP.get_response(uri)
# end

# def read_https(url)
#   response = nil
#   uri = URI(url)

#   http = Net::HTTP.new(uri.host, uri.port)
#   http.use_ssl = true
#   http.start do |http|
#     response = Net::HTTP.get_response(uri)
#   end
#   response
# end

# raise "missing url" unless ARGV.count == 1

# site = ARGV[0]
# site = 'http://' + ARGV[0] unless ARGV[0].start_with?('http://') || ARGV[0].start_with?('https://')
# db_name = "noname.db"
# db_name = site.gsub("http://", "") if site.start_with?('http://')
# db_name = site.gsub("https://", "") if site.start_with?('https://')
# db_name += ".db"

# DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, db_name)}")
# DataMapper.finalize
# DataMapper.auto_migrate!


# puts "Already found URLs for #{site}"
# Url.all.each do |url|
#   puts "#{url}"
# end


# puts "Crawling #{site} - saving data on #{db_name}"
# saved=0
# Anemone.crawl("#{site}", :discard_page_bodies => true, :depth_limit=>2) do |anemone|
#   anemone.on_every_page do |page|

#     res = read_http(page.url)   if page.url.instance_of?(URI::HTTP)
#     res = read_https(page.url)  if page.url.instance_of?(URI::HTTPS)

#     puts "#{page.url} is a redirect to #{res['location']}" if res.code.to_i == 301

#     if res.code.to_i == 200
#       doc = Nokogiri::HTML(res.body)
#       puts "#{page.url} (depth: #{page.depth}, forms:#{doc.search("//form").count}) "
#     end

#     puts "#{page.url} was not found"                if res.code.to_i == 404
#     puts "#{page.url} requires authorization"       if res.code.to_i == 401
#     puts "#{page.url} returns an application error" if res.code.to_i == 500

#     if ! Url.first(:url=>page.url)
#       u = Url.new
#       u.url = page.url
#       u.depth = page.depth
#       u.forms = doc.css("form").map{ |a| (a['name'].nil?)? "nonamed":a['name'] }.compact.to_s.gsub("\n", ",") unless doc.nil?
#       u.code = res.code.to_i
#       u.redirect = res['location'] if res.code.to_i == 301

#       ret = u.save
#       saved += 1 if ret
#       if ! ret

#         puts "#{page.url} not saved"
#         u.errors.each do |e|
#           puts " * #{e}"
#         end
#       end

#     end

#   end
# end

# puts "#{saved} new urls saved on #{db_name}"
