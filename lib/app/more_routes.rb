class App < Sinatra::Base
  ('/a/a/a'..'/z/z/z').each do |path|
    get(path) { pass }
  end
end
