GEO_REDIS   = "geo"

class MainController < ApplicationController
  include ActionController::Live

  skip_before_action :verify_authenticity_token, if: :json_request?

  def main
  end

  def stream

    # Save unneeded database connections for other users
    ActiveRecord::Base.connection_pool.release_connection
    redis = Redis.new(url: REDIS_URL)

    geohash  = rand(1000)
    username = params[:username] || rand(1000)
    while true
      if redis.zscore(GEO_REDIS, username).nil?
        redis.zadd(GEO_REDIS, geohash, username)
        break
      end
      username = rand(100000000)
    end

    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    redis.subscribe(username) do |on|
      on.message do |event, data|
puts "???????????? #{data}, #{username}, #{event}"
        sse.write(data, event: 'custom')
        sse.write({ time: Time.now }.to_json)
      end
    end
  rescue IOError
    # Client disconnected
  ensure
    sse.close
    redis.zrem(GEO_REDIS, username)
    redis.quit
  end

  def say
    msg = params.require(:msg)
    data = { msg: msg }.to_json

    redis = Redis.new(url: REDIS_URL)
    redis.zrange(GEO_REDIS, 0, -1).each do |username|
      msg_count = redis.publish(username, data)

      # Remove username if he/she is offline and therefore not subscribing
      redis.zrem(GEO_REDIS, username) if msg_count == 0
    end
    render json: { ok: true }
  end


  # -------------------------------------------------------
  # Filters
  #
  def json_request?
    request.format.json?
  end

end
