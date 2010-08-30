require 'app/autoloader'
require 'app'

App.set :do_reset, true

use Rack::Reloader, 0
run App
