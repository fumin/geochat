url = if Rails.env == 'production'
        # openshift
        "redis://:ZTNiMGM0NDI5OGZjMWMxNDlhZmJmNGM4OTk2ZmI5@127.6.23.3:16379"
      else
        nil
      end

Redis.current = Redis.new url: url

if 'test' == Rails.env
  Redis.current.select('9')
end
