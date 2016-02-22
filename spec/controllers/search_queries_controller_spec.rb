require 'rails_helper'

RSpec.describe Api::V0::SearchQueriesController, type: :controller do
  describe "actions" do
    describe "it creates a new search query" do
       @search= SearchQuery.create!(:title => "New title of book", :author => "Name of Author", :pub_date => "2016-02-20")
    end

    it "saves successfully to database" do
        expect(response.status).to eq(200)
    end

  end
end
