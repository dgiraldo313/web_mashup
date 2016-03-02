class CreateSearchQueriesTable < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.string  :title
      t.string  :author
      t.integer :start_pub_date, :default => 1500
      t.integer :end_pub_date
      t.string  :DPLA_URL
      t.timestamps null: false
    end
  end
end
