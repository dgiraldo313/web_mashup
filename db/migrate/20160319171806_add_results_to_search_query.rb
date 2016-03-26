class AddResultsToSearchQuery < ActiveRecord::Migration
  def change
    add_column :search_queries, :results, :text
  end
end
