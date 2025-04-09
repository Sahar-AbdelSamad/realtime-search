class CreateTopSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :top_searches do |t|
      t.string :query, null: false
      t.integer :count, default: 0
      t.string :user_ip

      t.timestamps
    end
  end
end
