class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :institution
      t.string :API_key
      t.timestamps null: false
    end
  end
end
