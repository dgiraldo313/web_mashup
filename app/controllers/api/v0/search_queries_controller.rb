class Api::V1::SearchQueriesController < ApplicationController
  respond_to :html, :xml

  def index
    respond_with SearchQuery.all
  end

  def show
    respond_with user
  end

  def create
    respond_with :api, :v1, User.create(user_params)
  end


  private

  def User
    SearchQuery.find(params[:id])
  end

  def user_params
    params.require(:search_query).permit(:title, :author, :pub_date)
  end
end
