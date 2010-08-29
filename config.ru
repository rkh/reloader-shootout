require 'app'
require 'app/autoloader'
App.register Sinatra::Reloader
run App
