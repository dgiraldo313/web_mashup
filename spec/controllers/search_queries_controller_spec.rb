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
    describe "perform_search" do
      before :all do
        @search = Api::V0::SearchQueriesController.new
        @search.create
        @search.title = "new title"
        @search.author = 'new author'
        @search.start_pub_year = 1500
        @search.end_pub_year = 2015
      end

      it 'should remove whitespace' do
        /^[^\s]+$/.match(@search.new_title).should_not eq(nil)
        /^[^\s]+$/.match(@search.new_author).should_not eq(nil)
      end

      it 'should get the API key from a file' do
        @api_key.should_not eq(nil)
      end

      it 'should parse the JSON doc and return a url' do
        @DPLA_URL.should_not eq(nil)
      end
    end
  end
end
