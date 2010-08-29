class App < Sinatra::Base
  module MyHelpers
    def title
      "Fancy Page"
    end
  end
end
