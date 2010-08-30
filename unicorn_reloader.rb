#!/usr/bin/env ruby
# adapted from Jonathan D. Stott's reloading script
# http://namelessjon.posterous.com/magical-reloading-sparkles
require 'directory_watcher'
system "bundle exec unicorn --daemonize --config-file unicorn.config.rb config.ru"
pid     = File.read('./unicorn.pid').to_i
watcher = DirectoryWatcher.new 'lib', :scanner => :rev, :pre_load => true
watcher.add_observer { |*a| a.each { |e| Process.kill :HUP, pid }}

trap "INT" do
  Process.kill :QUIT, pid
  watcher.stop
  exit
end

sleep
