require 'sinatra/base'

class App < Sinatra::Base
  autoload :MyHelpers, 'app/my_helpers'
  autoload :Extension, 'app/extension'
end
