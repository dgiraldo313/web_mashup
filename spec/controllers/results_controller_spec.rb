require 'rails_helper'

RSpec.describe ResultsController, type: :controller do
  describe "actions" do
    describe "it creates a new result" do
       @result= Result.create!(:resource1 => "url", :resource2 => "url", :resource3 => "url")
    end

    it "saved successfully to database" do
        expect(response.status).to eq(200)
    end

  end
end
