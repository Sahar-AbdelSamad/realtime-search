class SearchQuery < ApplicationRecord
  validates :query, presence: true, length: { minimum: 1 }
  validates :user_ip, presence: true
  
  # Clean up query data by removing incomplete queries.
  def self.clean_and_save(query, user_ip)
    # Only store complete searches
    return if query.strip.empty?
    SearchQuery.create(query: query, user_ip: user_ip)

    top_search = TopSearch.find_or_initialize_by(query: query, user_ip: user_ip)
    top_search.count = top_search.count.to_i + 1
    top_search.save
  end
end

