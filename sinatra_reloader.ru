require 'app/autoloader'
require 'app'
require 'sinatra/reloader'
App.register Sinatra::Reloader
run App
