class CreateSearchQueries < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.string :title
      t.string :author
      t.date :pub_date
      t.timestamps null: false
    end
  end
end
