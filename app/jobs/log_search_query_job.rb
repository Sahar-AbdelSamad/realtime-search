class LogSearchQueryJob < ApplicationJob
  queue_as :default

  def perform(query, user_ip)
     # Fetch the last query from the database
     last_query = SearchQuery.order(created_at: :desc).limit(1).first

     # Check if the current query differs by 2 or more characters
     if last_query && (last_query.query.length - query.length).abs == 1 
       # If the user deleted a character (query is shorter by one character), delete the last query
       last_query.destroy
     end
 
     # Save the current query
     SearchQuery.clean_and_save(query, user_ip)
  end
end
