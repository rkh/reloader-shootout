require 'sinatra/base'

class App < Sinatra::Base
  reset! if respond_to? :do_reset? and do_reset?
  helpers MyHelpers
  register Extension
  set :inline_templates, __FILE__
  routes_from 'app/more_routes.rb'
  get('/') { haml :index }
end

__END__

@@ index
Chunky Bacon!

@@ layout
!!!
%html
  %head
    %title= title
  %body
    != yield
