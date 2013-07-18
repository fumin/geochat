class MainController < ApplicationController

  skip_before_action :verify_authenticity_token, if: :json_request?

  def main
  end

  def say
    msg       = params.require(:msg)
    latitude  = params.require(:latitude).to_f
    longitude = params.require(:longitude).to_f
    data = { msg:       msg,
             latitude:  latitude,
             longitude: longitude }.to_json

    # Send message to people around an area of width 2.4kM (precision 5)
    # Algorithm from
    # https://groups.google.com/forum/#!topic/redis-db/Mw0lRzutnkE
    precision = (params[:precision] || 5).to_i
    min, max = GeoHash.bounds_in_int(latitude, longitude, precision)
    redis = Redis.new(url: REDIS_URL)
    redis.zrangebyscore(GEO_REDIS, min, max,
                        limit: [0, 500]).each do |username|
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
