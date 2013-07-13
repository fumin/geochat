class MainController < ApplicationController
  include ActionController::Live

  def main
  end

  def stream
puts "1111111111111111111"

    # Save unneeded database connections for other users
    ActiveRecord::Base.connection_pool.disconnect!
puts "2222222222222"
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
puts "33333333333333333"
    100.times { |i|
      sse.write({ i: i }, event: 'custom')
      sse.write({ time: Time.now })
      puts ">>>>>>>>>>>>>>>>>>>>>> #{i}"
      sleep(3)
    }
puts "4444444444444444444444444"
    sse.close
  end

end
