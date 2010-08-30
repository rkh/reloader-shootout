require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths  = ['lib']
ActiveSupport::Dependencies.mechanism       = :load

module ReloadingApp
  def self.call(env)
    require_dependency 'app'
    App.call(env)
  ensure
    ActiveSupport::Dependencies.clear
  end
end

run ReloadingApp
