Rspec.describe Api::V0::SearchQueriesController do
	describe "perform_search" do
		before :all do
			@search = SearchQueriesController.new
			@search.search_prep()
			@url = @search.generate
			@response = fetch(@url)
			@doc = perform_search
		end

		it 'should remove whitespace' do
			/^[^\s]+$/.match(@search.@new_title).should_not eq(nil)
			/^[^\s]+$/.match(@search.@new_author).should_not eq(nil)
		end

		it 'should get the API key from a file' do
			@api_key.should_not eq(nil)
		end

		it 'should retrieve an xml doc' do
			@doc.should_not eq(nil)
		end

		it 'should parse the xml doc and return a name and url' do
			@results = @search.parse(@doc)
			@results.should_not eq(nil)
		end
	end
end