class App < Sinatra::Base
  module Extension
    def routes_from(file)
      return routes.empty?
      load(file)
    rescue LoadError
      load File.join('..', file)
    end
  end
end
