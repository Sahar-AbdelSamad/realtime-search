class LogSearchQueryJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(query, user_ip)
     # Fetch the last query from the database
     last_query = SearchQuery.order(created_at: :desc).limit(1).first

     # Check if the current query differs by 1 or more characters
     if last_query && (last_query.query.length - query.length).abs == 1 
       # If the user deleted or added a character, delete the last query
       last_query.destroy
      TopSearch.decrement_search_count(query: last_query)
     end

     SearchQuery.clean_and_save(query, user_ip)
     TopSearch.increment_search_count(query: last_query)
  end
end
