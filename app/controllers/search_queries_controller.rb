class SearchQueriesController < ApplicationController

  def index
    @recent_searches = SearchQuery.order(created_at: :desc).limit(10)
    @top_searches = TopSearch.order(count: :desc).limit(10)
  end
  def create
    query = params[:query]
    user_ip = request.remote_ip

    # Immediately queue the background job to log the search
    #LogSearchQueryJob.perform_later(query, user_ip)

    last_query = SearchQuery.order(created_at: :desc).limit(1).first

    # Check if the current query differs by 1 or more characters
    if last_query && (last_query.query.length - query.length).abs == 1
      # If the user deleted or added a character, delete the last query
      last_query.destroy
     TopSearch.decrement_search_count(query: last_query)
    end

    SearchQuery.clean_and_save(query, user_ip)
    TopSearch.increment_search_count(query: last_query)

    Pusher.trigger('search', 'create', { query: query })

    render json: { result: "You searched for #{query}, ip #{user_ip}" }, status: :ok
  end
  def analytics
    @top_searches = TopSearch.order(count: :desc).limit(10)
    @recent_searches = SearchQuery.order(created_at: :desc).limit(10)

    render json: { top_searches: @top_searches, recent_searches: @recent_searches }
  end
end
