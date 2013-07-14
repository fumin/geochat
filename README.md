# Geo Chat

## Pushing to production
* `rhc cartridge-stop ruby-1.9 --app geochat`
* `rhc ssh --app geochat`
  * We are now inside openshift
  * `bundle exec 'rainbows -p 8080 -c config/unicorn.rb'`
