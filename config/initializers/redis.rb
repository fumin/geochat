REDIS_URL = if Rails.env == 'production'
  # openshift
  "redis://:ZTNiMGM0NDI5OGZjMWMxNDlhZmJmNGM4OTk2ZmI5@127.6.23.3:16379"
            else
              nil
            end

MainController
