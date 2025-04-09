class CreateSearchQueries < ActiveRecord::Migration[7.1]
  def change
    create_table :search_queries do |t|
      t.string :query
      t.string :user_ip

      t.timestamps
    end

    add_index :search_queries, :query
    add_index :search_queries, :user_ip

  end
end
