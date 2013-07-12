Redis.current = Redis.new url: ENV['OPENREDIS_URL']

if 'test' == Rails.env
  Redis.current.select('9')
end
