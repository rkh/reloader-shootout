require 'sinatra/base'

class App < Sinatra::Base
  helpers MyHelpers
  register Extension
  enable :inline_templates
  routes_from 'app/more_routes'
  get('/') { haml :index }
end

__END__

@@@ index
Chunky Bacon!

@@@ layout
!!!
%html
  %head
    %title= title
  %body
    != yield
