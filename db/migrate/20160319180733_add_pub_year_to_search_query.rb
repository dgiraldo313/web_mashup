class AddPubYearToSearchQuery < ActiveRecord::Migration
  def change
    add_column :search_queries, :pub_year, :integer
  end
end
