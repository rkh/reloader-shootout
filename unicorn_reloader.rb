#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
# spawns a unicorn to serve a rack app in the given directory. Watches
# the app files for changes, restarting the unicorn worker when they're
# detected.
#
# A secondary watch passes the unicorn log through to the terminal.
#
# Copyright (c) 2010 Jonathan Stott.
# Released under the terms of the MIT License
require 'directory_watcher'

LOGFILE = "./unicorn.log" # unicorn's log file
PIDFILE = "./unicorn.pid" # unicorn's pid file
GLOB = ['lib/**/*.rb','app/**/*.rb','app.rb'] # glob of the application's files

# remove the old log
system "rm -f -- #{LOGFILE}"

# start the unicorn
system "unicorn --daemonize --config-file unicorn.config.rb config.ru"

# get the pid
pid = File.open(PIDFILE) { |f| f.read }.chomp.to_i

# open a watcher to read the log as it changes
log_watch = DirectoryWatcher.new File.dirname(LOGFILE),
  :glob => File.basename(LOGFILE),
  :pre_load => true

# open the logfile
log = File.open(LOGFILE)

# add an observer to read it
log_watch.add_observer do |*args|
  puts log.read
end


# watch our app for changes
dw = DirectoryWatcher.new '.',
  :glob => GLOB,
  :pre_load => true

# SIGHUP makes unicorn respawn workers
dw.add_observer do |*args|
  Process.kill :HUP, pid
end

# wrap this in a lambda, just to avoid repeating it
stop = lambda { |sig|
  Process.kill :QUIT, pid # kill unicorn
  dw.stop
  log_watch.stop
  exit
}

trap("INT", stop)

log_watch.start
dw.start
gets # when the user hits "enter" the script will terminate
stop.call(nil)