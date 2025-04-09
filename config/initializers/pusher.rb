    # config/initializers/pusher.rb
    
    require 'pusher'
    
    Pusher.app_id = "1972062"
    Pusher.key = "730aa68ef78b70a9d947"
    Pusher.secret = "389f2a64af1ab0d977e1"
    Pusher.cluster = "eu"
    Pusher.logger = Rails.logger
    Pusher.encrypted = true