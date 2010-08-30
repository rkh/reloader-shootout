require 'app'
require 'app/autoloader'

class FixedReloader < Rack::Reloader
  def reload!(stderr = $stderr)
    App.reset!
    super
  end
end

use FixedReloader, 0
run App
