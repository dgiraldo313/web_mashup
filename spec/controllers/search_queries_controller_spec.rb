require 'rails_helper'

RSpec.describe Api::V0::SearchQueriesController, type: :controller do
  describe "actions" do
    describe "creating new search queries" do
    #    @search= SearchQuery.create!(:title => "New title of book", :author => "Name of Author", :pub_date => "2016-02-20")
    # end

      it "saves search query successfully" do
          @search= SearchQuery.create!(:title => "New title of book", :author => "Name of Author", :pub_date => "2016-02-20")
          expect(response.status).to eq(200)
      end

      # describe "it tries to create a new search query with one field filled in" do
      #    @search= SearchQuery.create!(:title => "New title of book")
      # end

      it "fails to save with title field" do
          @search= SearchQuery.create!(:title => "New title of book")
          expect @search.save raise_error(ActiveRecord::RecordInvalid,"Validation failed: Author can't be blank, Pub date can't be blank")
      end
    end

  end
end
