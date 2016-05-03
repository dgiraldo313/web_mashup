require "net/http"
require "uri"
require "json"
require 'nokogiri'

class Libmash::Api::V1::SearchQueriesController < ApplicationController
  # returns both html and xml content
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :html, :json

  def new
    @search = SearchQuery.new
  end

  # creates a record of a search_query
  def create
    if !validate_present_of_fields()
      flash[:notice] = "Failed to search content. Please check that all the search fields are present"
      redirect_to '/libmash'
    else
      # if all fields are filled in
      # then we can start the process of building the JSON variable

      get_pub_date_range()

      # start empty JSON variable
      @result_hash= {}
      # get the url from DPLA and save to variable
      get_DPLA_url(@title, @author, @start_pub_year, @end_pub_year)
      get_gutenberg_url(@title, @author, @start_pub_year, @end_pub_year)

      @results = JSON.generate(@result_hash)

      render json: @results

    end
  end


  # Methods

  private

  def validate_present_of_fields()
    # gets fields ready to check if they are empty
    @title= getParamValues(:title)
    @author= getParamValues(:author)
    @pub_year= getParamValues(:pub_year)

    # conditional which checks to see that the user
    # passed in all the fields required
    if (@title.empty? || @author.empty? || @pub_year.empty?)
      return false
    else
      return true
    end
  end

  # Takes the publication date entered by the user and create a range
  def get_pub_date_range()
    @start_pub_year= ((getParamValues(:pub_year).to_i)-100).to_s
    @end_pub_year= ((getParamValues(:pub_year).to_i)+100).to_s
  end



  def search_prep(title, author, start_pub_year, end_pub_year)
    @new_title = title.to_s
    @new_title = @new_title.gsub(/[\s]/, '+')
    while @new_title[-1,1] == '+' do
       @new_title.chomp('+')
    end
    @new_author = author.to_s
    @new_author = @new_author.gsub(/[\s]/, '+')
    while @new_author[-1,1] == '+' do
      @new_author.chomp('+')
    end
    #api_key_file = open('./DPLA_API_KEY', "rb")
    begin
      #@api_key = api_key_file.read()
      @api_key = ENV['DPLA_API_KEY']
    rescue
      puts "Please create 'DPLA_API_KEY' with copy of DPLA key. See 'http://dp.la/info/developers/codex/policies/#get-a-key'"
      @api_key=nil
    end
    @start_date = start_pub_year.to_s
    @stop_date = end_pub_year.to_s
  end

  def gutenberg_search_prep(title, author, start_pub_year, end_pub_year)
    @guten_title = title.to_s
    @guten_title = @guten_title.gsub(/[\s]/, '+')
    while @guten_title[-1,1] == '+' do
       @guten_title.chomp('+')
    end
  end

  # defines method to retrive the param values so that they can be passed to the get_DPLA_url method
  def getParamValues(field)
    if !field.nil?
      return params.require(:search_query).permit(field)[field]
    end
  end
 #changes
  ##WYATT
  # This is the function that will create the get request to
  # retrieve the url through the DPLA API.
  # this function should add results to result hash.
  def get_DPLA_url(title, author, start_pub_year, end_pub_year)
    search_prep(title, author, start_pub_year, end_pub_year)
    base_url = 'http://api.dp.la'
    search_url = '/v2/items?'
    search_url += ('sourceResource.title=' + @new_title + '&sourceResource.creator=' + @new_author + '&sourceResource.date.after=' + @start_date + '&sourceResource.date.before=' + @stop_date + '&api_key=' + @api_key )
    final_url = base_url + search_url
    final_url_uri = URI.parse(final_url)
    response = Net::HTTP.get_response(final_url_uri)
    response_body = response.body
    data_hash = JSON.parse(response_body)
    #json_data = Net::HTTP.get(URI.parse(search_url))
    #file = file.read(json_data)
    #data_hash = JSON.parse(json_data)

    #add DPLA content to hash
    count = data_hash["count"]
    dpla_hash= @result_hash[:DPLA]= {:count=>count}
    if count> 10
      count = 10
    end
    if count > 0
      for i in 0..(count-1)
        begin
          title = data_hash["docs"][i]["sourceResource"]["title"]
          creator = data_hash["docs"][i]["sourceResource"]["creator"]
          pub_date = data_hash["docs"][i]["sourceResource"]["date"]["end"]
          provider = data_hash["docs"][i]["provider"]["name"]
          publisher = data_hash["docs"][i]["sourceResource"]["publisher"]
          url = data_hash["docs"][i]["isShownAt"]
          begin
            city = data_hash["docs"][i]["sourceResource"]["spatial"]["city"]
            country = data_hash["docs"][i]["sourceResource"]["spatial"]["country"]
            location = city + ", " + country
            dpla_hash[i]= {:title=>title, :author => creator, :pub_date=> pub_date, :provider=> provider, :publisher=> publisher, :location=> location, :url => url}
          rescue Exception => e
            dpla_hash[i]= {:title=>title, :author => creator, :pub_date=> pub_date, :provider=> provider, :publisher=> publisher, :url => url}
          end
        rescue
          url = nil
        end
      end
    end

    #build url to send request to api (Ex. api.dpla.com/?title....)
    # figure out how to make GET request with ruby
      #http://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html this looks like a good resoruce to figure out get requests on ruby
    #request should be made here
    # request should either return the direct url to the content or nil if nothing found
    #url+="title="+title+",author="+author+",start_pub_year"+start_pub_year+",end_pub_year="+end_pub_year

  end

  def get_gutenberg_url(title, author, start_pub_year, end_pub_year)
    gutenberg_search_prep(title, author, start_pub_year, end_pub_year)
    base_url = 'https://www.gutenberg.org/ebooks/search/?query='
    search_url = (@guten_title)
    final_url = base_url + search_url
    final_url_uri= URI.parse(final_url)
    html =  Net::HTTP.get(final_url_uri)
    response = Nokogiri::HTML(html)
    showings = []
    count = 0

    response.css('.booklink').each do |booklink|
      count = count + 1
      link = booklink.css('a.link').map { |link| link['href'] }
      gberg_final_link = ('https://www.gutenberg.org' + link[0])
      gberg_title = booklink.css('.title').map { |title| title.text.strip }
      gberg_subtitle = booklink.css('.subtitle').map { |title| title.text.strip }
    showings.push(
    link: gberg_final_link,
    title: gberg_title[0],
    subtitle: gberg_subtitle[0]
    )
    end

    final_count = count
    gberg_hash = JSON.pretty_generate(showings)

    data_hash = JSON.parse(gberg_hash)


    gutenberg_hash= @result_hash[:Project_Gutenberg]= {:count=>final_count}
    if count> 10
      count = 10
    end
    if count > 0
      for i in 0..(count-1)
        begin
          title =  data_hash[i]["title"]
          creator = data_hash[i]["subtitle"]
          pub_date = "not_available"
          provider = "not_available"
          publisher = "not_available"
          url = data_hash[i]["link"]
          begin
            city = "not_available"
            country = "not_available"
            location = "not_available"
            gutenberg_hash[i]= {:title=>title, :author => creator, :url => url}
          rescue Exception => e
            gutenberg_hash[i]= {:title=>title, :author => creator, :url => url}
          end
        rescue
          url = nil
        end
      end
    end
  end # end of guten method
end
