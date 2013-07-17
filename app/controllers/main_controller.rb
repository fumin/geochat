class MainController < ApplicationController

  skip_before_action :verify_authenticity_token, if: :json_request?

  def main
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
