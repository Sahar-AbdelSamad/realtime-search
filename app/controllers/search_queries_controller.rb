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
    @top_searches = TopSearch.order(count: :desc).limit(10)
    
    render json: { top_searches: @top_searches }
  end
end
