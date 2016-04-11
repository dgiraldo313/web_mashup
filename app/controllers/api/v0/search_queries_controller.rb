require "net/http"

class Api::V0::SearchQueriesController < ApplicationController
  # returns both html and xml content
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :html, :json

  # method that collects all search queries in records
  def index
    respond_with SearchQuery.all
  end

  # method that displays a particular instance of a search
  def show
    @search= search_query
    respond_with @search
  end

  def new
    @search = SearchQuery.new
  end

  # creates a record of a search_query
  def create

    if !validate_present_of_fields()
      flash[:notice] = "Failed to search content. Please check that all the search fields are present"
      redirect_to root_path
    else
      # if all fields are filled in
      # then we can start the process of building the JSON variable
      get_pub_date_range()
      # start empty JSON variable
      @result_hash= {}
      # get the url from DPLA and save to variable
      get_DPLA_url(@title, @author, @start_pub_year, @end_pub_year)
      @results = JSON.generate(@result_hash)
      render json: @results
    end
  end

    # save parameters from form onto variables
    @title= getParamValues(:title)
    @author= getParamValues(:author)
    @start_pub_year= getParamValues(:start_pub_year)
    @end_pub_year= getParamValues(:end_pub_year)
<<<<<<< HEAD
=======

>>>>>>> Jega_Working
    # get the url from DPLA and save to variable
    @DPLA_URL = get_DPLA_url(@title, @author, @start_pub_year, @end_pub_year)
    @search= SearchQuery.create(search_params.merge(:DPLA_URL => @DPLA_URL))
    # redirect_to api_v0_search_query_path(@search)
    if @search.save
      respond_with :api, :v0, @search
    else
      flash[:notice] = "Failed to search content"
      redirect_to search_path
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

  # defines the require parameters needed to create a search query
  def search_params
    params.require(:search_query).permit(:title, :author, :start_pub_year, :end_pub_year)
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
    api_key_file = open('./DPLA_API_KEY', "rb")
    begin
      @api_key = api_key_file.read()
    rescue
      puts "Please create 'DPLA_API_KEY' with copy of DPLA key. See 'http://dp.la/info/developers/codex/policies/#get-a-key'"
      @api_key=nil
    end
    @start_date = start_pub_year.to_s
    @stop_date = end_pub_year.to_s
  end

  # defines method to retrive the param values so that they can be passed to the get_DPLA_url method
  def getParamValues(field)
    if !field.nil?
      return params.require(:search_query).permit(field)[field]
    end
  end

  ##WYATT
  # This is the function that will create the get request to
  # retrieve the url through the DPLA API.
  # Basically we need to make a GET request to the API.
  # We can put together the url by using the parameters passed in to the function( author, title, etc..)
  # this function should return a string with the url to the microfiche or null if nothing found.
  def get_DPLA_url(title, author, start_pub_year, end_pub_year)
    search_prep(title, author, start_pub_year, end_pub_year)
    base_url = 'api.dp.la'
    search_url = '/v2/items?'
    search_url += ('sourceResource.title=' + @new_title + '&sourceResource.creator=' + @new_author + '&sourceResource.date.after=' + @start_date + '&sourceResource.date.before=' + @stop_date  + '&api_key=' + @api_key )
    response = Net::HTTP.get_response(base_url,search_url)
    response_body = response.body
    data_hash = JSON.parse(response_body)
    #json_data = Net::HTTP.get(URI.parse(search_url))
    #file = file.read(json_data)
    #data_hash = JSON.parse(json_data)
    begin
      url = data_hash["docs"][0]["isShownAt"]
    rescue
     url = nil
    end

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
<<<<<<< HEAD
=======
   end
>>>>>>> Jega_Working

    #build url to send request to api (Ex. api.dpla.com/?title....)
    # figure out how to make GET request with ruby
      #http://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html this looks like a good resoruce to figure out get requests on ruby
    #request should be made here
    # request should either return the direct url to the content or nil if nothing found
    #url+="title="+title+",author="+author+",start_pub_year"+start_pub_year+",end_pub_year="+end_pub_year

  end
end

#Jega
#This is the function that will create the get request to
# retrieve the url through the HathiTrust API.
# We would need to make a GET request to the API.
# Configure together the url by using the parameters passed in to the function( author, title, etc..)
# this function should return a string with the url to the microfiche or null if nothing found.

def get_HathiTrust_url(title, author, start_pub_year, end_pub_year)
  search_prep(title, author, start_pub_year, end_pub_year)
  base_url = 'https://www.hathitrust.org/data_api'
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

  #add HathiTrust content to hash
  count = data_hash["count"]
  dpla_hash= @result_hash[:HathiTrust]= {:count=>count}
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
          hathitrust_hash[i]= {:title=>title, :author => creator, :pub_date=> pub_date, :provider=> provider, :publisher=> publisher, :location=> location, :url => url}
        rescue Exception => e
          hathitrust_hash[i]= {:title=>title, :author => creator, :pub_date=> pub_date, :provider=> provider, :publisher=> publisher, :url => url}
        end
      rescue
        url = nil
      end
    end
<<<<<<< HEAD
  return url
end
=======
  end
  return url
end
end
>>>>>>> Jega_Working
