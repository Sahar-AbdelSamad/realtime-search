# class SearchQueriesController < ApplicationController
#   def index
#     respond_to do |format|
#       format.html do
#         # Display the most recent search queries (for example)
#         @recent_searches = SearchQuery.order(created_at: :desc).limit(10)
#         render :index # Explicitly tell Rails to render index.html.erb
#       end
#       format.json do
#         # Respond with JSON for API requests
#         render json: { success: true }
#       end
#     end
#   end
  
#   def create
#     query = params[:query]
#     user_ip = request.remote_ip

#     # Log the query to database
#     SearchQuery.clean_and_save(query, user_ip)

#     render json: { success: true }, status: :ok
#   end

#   def analytics
#     @top_searches = SearchQuery.top_searches  # Assuming `top_searches` is defined in your model

#     # Send the top search data as JSON
#     render json: { top_searches: @top_searches }
#   end
  
# end


class SearchQueriesController < ApplicationController
  def index
    # Get recent searches to display in the view (optional)
    @recent_searches = SearchQuery.order(created_at: :desc).limit(10)
  end
  def create
    query = params[:query]
    user_ip = request.remote_ip

    # Fetch the last query from the database
    last_query = SearchQuery.order(created_at: :desc).limit(1).first

    # Check if the current query differs by 2 or more characters
    if last_query && (last_query.query.length - query.length).abs == 1 
      # If the user deleted a character (query is shorter by one character), delete the last query
      last_query.destroy
    end

    # Save the current query
    SearchQuery.clean_and_save(query, user_ip)
    # Fetch the most recent query after saving
    last_query = SearchQuery.order(created_at: :desc).limit(1).first
    render json: { result: "You searched for #{last_query.query}, ip #{user_ip}" }, status: :ok
  end
  def analytics
    # Retrieve the top search queries from the 'top_searches' table
    @top_searches = TopSearch.order(count: :desc).limit(10)
    
    # Respond with top searches in JSON format for AJAX updates
    render json: { top_searches: @top_searches }
  end
end
