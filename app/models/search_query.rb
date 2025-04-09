class SearchQuery < ApplicationRecord
  validates :query, presence: true, length: { minimum: 1 }
  validates :user_ip, presence: true

  # Clean up query data by removing incomplete queries.
  def self.clean_and_save(query, user_ip)
    # Only store complete searches
    return if query.strip.empty?
    SearchQuery.create(query: query, user_ip: user_ip)
  end

  # Aggregate top queries for analytics
  def self.log_query(query)
    # Find the existing search query or create a new one
    search = TopSearch.find_or_initialize_by(query: query)

    # Increment the count by 1
    search.count ||= 0
    search.count += 1

    # Save the record
    search.save
  end

  def self.top_searches
    # Retrieve top search queries ordered by the most searched (highest count)
    TopSearch.order(count: :desc).limit(10)
  end
end

