require "monkeypatches/pr_geohash"

class LiveController < ApplicationController
  include ActionController::Live

  def stream

    # Save unneeded database connections for other users
    ActiveRecord::Base.connection_pool.release_connection
    redis = Redis.new(url: REDIS_URL)

    latitude  = params.require(:latitude).to_f
    longitude = params.require(:longitude).to_f

    geohash  = GeoHash.encode_to_int(latitude, longitude)
    username = params[:username] || rand(1000)
    while true
      if redis.zscore(GEO_REDIS, username).nil?
        redis.zadd(GEO_REDIS, geohash, username)
        break
      end
      username = rand(100000000)
    end

    begin
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
  end

end
