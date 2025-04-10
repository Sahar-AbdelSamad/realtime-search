class SearchQueriesController < ApplicationController

  def index
    user_ip = request.remote_ip
    @recent_searches = SearchQuery.where(user_ip: user_ip).order(created_at: :desc).limit(10)
    @top_search = TopSearch.where(user_ip: user_ip).order(count: :desc).limit(10) 

    @top_search_last_30_days = TopSearch.where('created_at >= ?', 30.days.ago).order(count: :desc).limit(10)
    @top_search_allusers = TopSearch.order(count: :desc).limit(10)
  end
  def create
    query = params[:query].downcase
    user_ip = request.remote_ip

    # Immediately queue the background job to log the search
    #LogSearchQueryJob.perform_later(query, user_ip)

    last_query = SearchQuery.order(created_at: :desc).limit(1).first

    # Check if the current query differs by 1 or more characters
    if last_query && (last_query.query.length - query.length).abs == 1
      # If the user deleted or added a character, delete the last query
      last_query.destroy

      # Remove the count of the query in the TopSearch table
      top_search = TopSearch.find_by(query: last_query.query, user_ip: last_query.user_ip)
      if top_search
      top_search.count -= 1
      top_search.count.zero? ? top_search.destroy : top_search.save
      end
    end

    SearchQuery.clean_and_save(query, user_ip)

    Pusher.trigger('search', 'create', { query: query })

    render json: { result: "You searched for #{query}, ip #{user_ip}" }, status: :ok
  end
  def analytics
    user_ip = request.remote_ip
    @recent_searches = SearchQuery.where(user_ip: user_ip).order(created_at: :desc).limit(10)
    @top_search = TopSearch.where(user_ip: user_ip).order(count: :desc).limit(10)

    @top_search_last_30_days = TopSearch.where('created_at >= ?', 30.days.ago).order(count: :desc).limit(10)
    @top_search_allusers = TopSearch.order(count: :desc).limit(10)

    render json: { top_search: @top_search, recent_searches: @recent_searches, top_search_last_30_days: @top_search_last_30_days, top_search_allusers: @top_search_allusers }, status: :ok
  end
end
