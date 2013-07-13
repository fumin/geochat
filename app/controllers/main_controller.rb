class MainController < ApplicationController
  include ActionController::Live

  def main
  end

  def stream

    # Save unneeded database connections for other users
    ActiveRecord::Base.connection_pool.disconnect!

    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    100.times { |i|
      sse.write({ i: i }, event: 'custom')
      sse.write({ time: Time.now })
      sleep(3)
    }
    sse.close
  end

end
