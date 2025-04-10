class TopSearch < ApplicationRecord
  # Validations
  validates :count, numericality: { greater_than_or_equal_to: 0 }

  # Increment the search count or create a new entry if it doesn't exist
  def self.increment_search_count(query)
    top_search = find_or_initialize_by(query)
    top_search.count = top_search.count.to_i + 1
    top_search.save
  end

  def self.decrement_search_count(query)
    top_search = find_or_initialize_by(query)
    top_search.count = top_search.count.to_i - 1
    top_search.save
  end
end
