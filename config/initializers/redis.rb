REDIS_URL = if Rails.env == 'production'
  # openshift
  "redis://:ZTNiMGM0NDI5OGZjMWMxNDlhZmJmNGM4OTk2ZmI5@127.7.218.2:16379"
            else
              nil
            end

# Redis keys
GEO_REDIS = "geo"
