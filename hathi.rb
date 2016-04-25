require "net/http"
require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry'

# query = 'qwerty'
# link = "https://babel.hathitrust.org/cgi/ls?field1=ocr;q1=#{query};a=srchls"
base_url_a = "https://babel.hathitrust.org/cgi/ls?field1=ocr;q1="
hathi_search_url = "atla"
base_url_b = ";a=srchls"
hathi_final_url = base_url_a + hathi_search_url + base_url_b

page = Nokogiri::HTML(open(URI::encode(hathi_final_url)))
# Hash Format
	# {
	# 	title:
	# 	author:
	# 	pub_date:
	# 	provider:
	# 	publisher:
	# 	url:
	# }

 data = {result: []}

page.css("div[class = 'row result alt']").each do |x|
	title, author, pub_date, url = ''

  # view-source:https://babel.hathitrust.org/cgi/ls?field1=ocr;q1=atla;a=srchls
  # <h4 class="Title"><span class="offscreen">Item 4: </span>Newsletter - American Theological Library Association.<span class="Title"> v.47 1999-2000</span></h4>
  #     <div class="result-metadata-author">
  #          <span class="ItemAuthorLabel">by </span>
  #          <span class="Author">American Theological Library Association.</span>
  #     </div>
  #          <div class="result-metadata-published">
  #          <span class="Date"><span class="ItemDateLabel">Published </span>2003</span>
  #     </div>
  #          <span class="Relevance debug">relevance score: 0.5110699</span>
  #          <div class="result-access-link">

	y = x.css('h4')
    title = y.children[1..2].text if y.length > 0

	if x.css('div.result-metadata-author').length > 0
		author = x.css('div.result-metadata-author').css('span.Author').text
	end
	if x.css("div.result-metadata-published").length > 0
		pub_date = x.css("div.result-metadata-published").text.gsub(/[^0-9]/, '')
	end

	if x.css('div.result-access-link').length > 0
		if x.css('div.result-access-link').css('ul').length > 0
			url = x.css('div.result-access-link').css('ul').css('li').css('a')[0]['href']
		end
	end

	data[:result] << {
				title: title,
				author: author,
				pub_date: pub_date,
				url: url
			}
end


hathi_data = JSON.pretty_generate(data)
# File.open("result#{Time.now.to_i}.json","w") do |f|
#   f.write(data.to_json)
# end

pry.start(binding)
