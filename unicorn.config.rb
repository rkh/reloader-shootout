worker_processes 1
pid         "./unicorn.pid"
stdout_path "./unicorn.log"
stderr_path "./unicorn.log"

before_fork do |server, worker|
  $LOAD_PATH.unshift './lib'
  require 'sinatra/base'
end
