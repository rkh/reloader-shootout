require 'app'
require 'app/autoloader'
require 'sinatra/reloader'
App.register Sinatra::Reloader
run App
