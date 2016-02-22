class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :resource1
      t.string :resource2
      t.string :resource3
      t.timestamps null: false
    end
  end
end
