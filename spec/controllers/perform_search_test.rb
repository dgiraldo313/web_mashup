Rspec.describe Api::V0::SearchQueriesController do
	describe "perform_search" do
		before :all do
			@search = SearchQueriesController.new
			@words = @search.search_prep
			@api_key = open('../DPLA_API_KEY')
			@url = @search.generate
			@doc = Nokogiri::XML(open(@url))
		end

		it 'should remove whitespace' do
			/^[^\s]+$/.match(@words).should_not eq(nil)
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