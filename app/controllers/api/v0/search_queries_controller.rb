class Api::V0::SearchQueriesController < ApplicationController
  # returns both html and xml content
  respond_to :xml, :html

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
    @search= SearchQuery.create(search_params)
    # redirect_to api_v0_search_query_path(@search)
    if @search.save
      respond_with :api, :v0, @search
    else
      flash[:notice] = "Failed to search content"
      redirect_to search_path
    end
  end
  
  def search_prep()
    @new_title = :title.to_s
    @new_title.gsub(/\s/, '+')
    while @new_title[-1,1] == '+' do
       @new_title.chomp('+')
    end
    @new_author = :author.to_s
    @new_author.gsub(/\s/, '+')
    while @new_author[-1,1] == '+' do
      @new_author.chomp('+')
    end
    api_key_file = open('./DPLA_API_KEY', "rb")
    @api_key = api_key_file.read()
    puts :pub_date
  end

  def generate()
    search_prep()
    base_url = 'http://api.dp.la/v2/items?'
    base_url += ('sourceResource.title=' + @new_title + '&sourceResource.creator=' + @new_author + '&api_key' = @api_key ) 
    return base_url
  end
  # Methods
  private
  # finds a search_query by id
  def search_query
    SearchQuery.find(params[:id])
  end

  # defines the require parameters needed to create a search query
  def search_params
    params.require(:search_query).permit(:title, :author, :pub_date)
  end
end
