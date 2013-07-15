# Geo Chat

## Pushing to production
* `rhc cartridge-stop ruby-1.9 --app geochat`
* `rhc ssh --app geochat`
  * We are now inside openshift
  * `cd app-root/runtime/repo`
  * `RACK_ENV=production bundle exec "rainbows -o $OPENSHIFT_RUBY_IP -p $OPENSHIFT_RUBY_PORT -c config/rainbows.rb"`

## OpenShift auto-generated

The OpenShift `diy` cartridge documentation can be found at:

https://github.com/openshift/origin-server/tree/master/cartridges/openshift-origin-cartridge-diy/README.md
