class RenamePubDateColumn < ActiveRecord::Migration
  def change
    rename_column :search_queries, :start_pub_date, :start_pub_year
    rename_column :search_queries, :end_pub_date, :end_pub_year
  end
end
