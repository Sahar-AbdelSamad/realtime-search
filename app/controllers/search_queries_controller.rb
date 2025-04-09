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
    @recent_searches = SearchQuery.order(created_at: :desc).limit(10)
  end
  def create
    query = params[:query]
    user_ip = request.remote_ip

    # Immediately queue the background job to log the search
    LogSearchQueryJob.perform_later(query, user_ip)

    Pusher.trigger('search', 'create', { query: query })

    # Fetch the most recent query after saving
    #last_query = SearchQuery.order(created_at: :desc).limit(1).first
    render json: { result: "You searched for #{query}, ip #{user_ip}" }, status: :ok
  end
  def analytics
    # Retrieve the top search queries from the 'top_searches' table
    @top_searches = TopSearch.order(count: :desc).limit(10)
    
    # Respond with top searches in JSON format for AJAX updates
    render json: { top_searches: @top_searches }
  end
end
