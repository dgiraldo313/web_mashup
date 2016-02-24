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
