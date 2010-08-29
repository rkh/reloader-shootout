require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths = ['lib']

module ReloadingApp
  def call(env)
    App.call(env)
  ensure
    ActiveSupport::Dependencies.clear
  end
end

run ReloadingApp
