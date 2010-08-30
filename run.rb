#!/usr/bin/env ruby
require 'benchmark'
require 'open-uri'

case file = ARGV.first
when /\.rb$/ then cmd = "bundle exec #{file}"
when /\.ru$/ then cmd = "bundle exec unicorn --config-file unicorn.config.rb #{file}"
else fail "cannot handle file #{file.inspect}"
end

$stderr.puts 'starting server'
pipe = IO.popen cmd

$stderr.print 'waiting for server'
begin
  $stderr.print '.'
  ping = open 'http://localhost'
