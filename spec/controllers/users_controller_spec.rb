require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "actions" do
    describe "it creates a new user" do
       @user= User.create!(:first_name => "Daniel", :last_name => "Giraldo", :institution => "Drew University", :API_key => "HKJHKJG1123JHK")
    end

    it "saved successfully to database" do
        expect(response.status).to eq(200)
    end

  end
end
