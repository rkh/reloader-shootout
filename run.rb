#!/usr/bin/env ruby
require 'benchmark'
require 'open-uri'
require 'backports'

case file = ARGV.first
when /\.rb$/ then cmd = "bundle exec #{file}"
when /\.ru$/ then cmd = "bundle exec unicorn --config-file unicorn.config.rb #{file}"
when nil # then nothing
else fail "cannot handle file #{file.inspect}"
end

url = 'http://localhost:8080'
[false,true].each do |modify|
  $stderr.print 'starting server' if cmd
  $last_str = 'Chunky Bacon'

  if cmd
    begin
      open url
      fail 'port already in use'
    rescue SocketError, Errno::ECONNREFUSED
    rescue StandardError
      count ||= 0
      $stderr.print '.'
      sleep 0.5
      if count > 100
        $stderr.print "\n"
        raise
      else
        retry
      end
    end
    $stderr.print "\n"

    pipe = IO.popen cmd
  end


  $stderr.print 'waiting for server'

  begin
    open url
  rescue StandardError
    count ||= 0
    $stderr.print '.'
    sleep 0.5
    if count > 100
      $stderr.print "\n"
      raise
    else
      retry
    end
  end

  $stderr.puts "\navailable"

  def change(both = true)
    code = File.read('lib/app.rb')
    code.gsub!(/Chunky Bacon|Funky Monkey/) do |str|
      $last_str = (both && str == 'Chunky Bacon' ? "Funky Monkey" : "Chunky Bacon")
    end
    File.open('lib/app.rb', 'w') { |f| f.write code }
  end

  kill = proc do
    if cmd
      $stderr.puts 'killing server'
      Process.kill :INT, pipe.pid
    end
    $stderr.puts 'reverting changes'
    change(false)
  end

  trap(:INT, kill)

  $stderr.print "measuring with#{'out' unless modify} changes"
  time = 40.times.map do
    $stderr.print '.'
    change if modify
    code = ''
    Benchmark.realtime { open url}
  end
  $stderr.print "\n"
  time = time[9..39].sum / 30
  puts "with#{'out' unless modify} changes: #{time}"

  kill[]
end
