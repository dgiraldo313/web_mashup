require 'rails_helper'

RSpec.describe Api::V0::SearchQueriesController, type: :controller do
  describe "actions" do
    describe "creating new search queries" do
    #    @search= SearchQuery.create!(:title => "New title of book", :author => "Name of Author", :pub_date => "2016-02-20")
    # end
  #
      it "saves search query successfully" do
          @search= SearchQuery.create!(:title => "Art?", :author => "Leslie Jones", :pub_year => "1940")
          expect(response.status).to eq(200)
      end


  #
      # describe "it tries to create a new search query with one field filled in" do
      #    @search= SearchQuery.create!(:title => "New title of book")
      # end
      #
      # it "fails to save with title field" do
      #     @search= SearchQuery.create!(:title => "New title of book")
      #     expect @search.save raise_error(ActiveRecord::RecordInvalid,"Validation failed: Author can't be blank, Pub date can't be blank")
      # end
    end
    describe "perform_search" do
      before :all do
        @search= SearchQuery.create!(:title => "new title", :author => "new author", :pub_year => "1940")
        # @search = Api::V0::SearchQueriesController.new
        # @search.create
        # @search.title = "new title"
        # @search.author = 'new author'
        # @search.start_pub_year = 1500
        # @search.end_pub_year = 2015
      end
  #
      it 'should make sure that fields are present' do
        (@search.title).should_not eq(nil)
        (@search.author).should_not eq(nil)
        (@search.pub_year).should_not eq(nil)
      end
    end

  #     it 'should get the API key from a file' do
  #       (@search..search_prep.api_key).should_not eq(nil)
  #     end
  #
  #     it 'should parse the JSON doc and return a url' do
  #       (@search.results).should_not eq(nil)
  #     end
  #   end
  # # end
  #   describe "perform_search" do
  # 		before :all do
  # 			@search = Api::V0::SearchQueriesController.new
  # 			@words = @search.search_prep
  # 			@api_key = open('DPLA_API_KEY')
  # 			@url = @search.generate
  # 			@doc = Nokogiri::XML(open(@url))
  # 		end
  #   #
  # 		it 'should remove whitespace' do
  # 			/^[^\s]+$/.match(@words).should_not eq(nil)
  # 		end
  #
  # 		it 'should get the API key from a file' do
  # 			@api_key.should_not eq(nil)
  # 		end
  #
  # 		it 'should retrieve an xml doc' do
  # 			@doc.should_not eq(nil)
  # 		end
  #
  # 		it 'should parse the xml doc and return a hash' do
  # 			@results = @search.parse(@doc)
  # 			@results.kind_of?(Hash).should eq(true)
  # 		end
  #
  #     # it 'should retrieve metadata for an entry' do
  #     #   @results.should eq
  #     # end
  #   end
  end
end
