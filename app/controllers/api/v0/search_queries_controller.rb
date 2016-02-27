class Api::V0::SearchQueriesController < ApplicationController
  # returns both html and xml content
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
    @title= params[:title]
    @author= params[:author]
    @start_pub_year= params[:start_pub_year]
    @end_pub_year= params[:end_pub_year]
    @DPLA_URL = get_DPLA_url(@title, @author, @start_pub_year, @end_pub_year)
    puts params[:title]
    @search= SearchQuery.create(search_params.merge(:DPLA_URL => @DPLA_URL))
    # redirect_to api_v0_search_query_path(@search)
    if @search.save

      respond_with :api, :v0, @search
    else
      flash[:notice] = "Failed to search content"
      redirect_to search_path
    end
  end


  # Methods
  private
  # finds a search_query by id
  def search_query
    SearchQuery.find(params[:id])
  end

  # defines the require parameters needed to create a search query
  def search_params
    params.require(:search_query).permit(:title, :author, :start_pub_year, :end_pub_year)
  end

  ##WYATT
  # This is the function that will create the get request to
  # retrieve the url through the DPLA API.
  # Basically we need to make a GET request to the API.
  # We can put together the url by using the parameters passed in to the function( author, title, etc..)
  # this function should return a string with the url to the microfiche or null if nothing found.
  def get_DPLA_url(title, author, start_pub_year, end_pub_year)
    #build url to send request to api (Ex. api.dpla.com/?title....)
    # figure out how to make GET request with ruby
      #http://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html this looks like a good resoruce to figure out get requests on ruby
    #request should be made here
    # request should either return the direct url to the content or nil if nothing found
    url= "This will be a url to the outside content"
    return url
  end

end
