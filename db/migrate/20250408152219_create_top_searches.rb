class CreateTopSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :top_searches do |t|
      t.string :query, null: false
      t.integer :count, default: 0

      t.timestamps
    end

    add_index :top_searches, :query, unique: true  # Optional: Ensures that each query is unique
  end
end
