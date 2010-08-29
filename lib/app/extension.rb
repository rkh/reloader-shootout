class App < Sinatra::Base
  module Extension
    def routes_from(file)
      load(file) if routes.empty?
    end
  end
end
