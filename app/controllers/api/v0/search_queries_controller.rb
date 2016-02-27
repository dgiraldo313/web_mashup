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
    # save parameters from form onto variables
    @title= getParamValues(:title)
    @author= getParamValues(:author)
    @start_pub_year= getParamValues(:start_pub_year)
    @end_pub_year= getParamValues(:end_pub_year)

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

  def search_prep()
    @new_title = @title.to_s
    @new_title.gsub(/\s/, '+')
    while @new_title[-1,1] == '+' do
       @new_title.chomp('+')
    end
    @new_author = @author.to_s
    @new_author.gsub(/\s/, '+')
    while @new_author[-1,1] == '+' do
      @new_author.chomp('+')
    end
    api_key_file = open('./DPLA_API_KEY', "rb")
    @api_key = api_key_file.read()
    @start_date = "1-1-" + @start_pub_year.to_s
    @stop_date = "12-31-" + @end_pub_year.to_s
  end

  # defines method to retrive the param values so that they can be passed to the get_DPLA_url method
  def getParamValues(field)
    return params.require(:search_query).permit(field)[field]
  end

  ##WYATT
  # This is the function that will create the get request to
  # retrieve the url through the DPLA API.
  # Basically we need to make a GET request to the API.
  # We can put together the url by using the parameters passed in to the function( author, title, etc..)
  # this function should return a string with the url to the microfiche or null if nothing found.
  def get_DPLA_url(title, author, start_pub_year, end_pub_year)
    search_prep()
    search_url = 'http://api.dp.la/v2/items?'
    search_url += ('sourceResource.title=' + @new_title + '&sourceResource.creator=' + @new_author + 'sourceResource.date.after' + start_date + 'sourceResource.date.before' + stop_date + '&api_key' = @api_key ) 
    
    #build url to send request to api (Ex. api.dpla.com/?title....)
    # figure out how to make GET request with ruby
      #http://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html this looks like a good resoruce to figure out get requests on ruby
    #request should be made here
    # request should either return the direct url to the content or nil if nothing found
    url= "This will be a url to the outside content/?"+"title="+title+",author="+author+",start_pub_year"+start_pub_year+",end_pub_year="+end_pub_year

    return url
  end

end
