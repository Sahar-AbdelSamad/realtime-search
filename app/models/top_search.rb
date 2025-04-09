class TopSearch < ApplicationRecord
  # Validations
  validates :query, presence: true, uniqueness: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }

  # Increment the search count or create a new entry if it doesn't exist
  def self.increment_search_count(query)
    top_search = find_or_initialize_by(query: query)
    top_search.count ||= 0
    top_search.count += 1
    top_search.save
  end
end
