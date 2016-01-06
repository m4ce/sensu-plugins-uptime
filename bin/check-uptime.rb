#!/usr/bin/env ruby
#
# check-uptime.rb
#
# Author: Matteo Cerutti <matteo.cerutti@hotmail.co.uk>
#

require 'sensu-plugin/check/cli'

class CheckUptime < Sensu::Plugin::Check::CLI
  option :uptime,
         :description => "Uptime in seconds",
         :long => "--uptime <UPTIME>",
         :proc => proc(&:to_i),
         :default => 300

  option :warn,
         :description => "Warn instead of throwing a critical failure",
         :short => "-w",
         :long => "--warn",
         :boolean => true,
         :default => false

  def initialize()
    super

    @uptime = get_uptime()
  end

  def get_uptime()
    %x[cat /proc/uptime].split(' ').first.to_i
  end

  def run
    if config[:uptime] >= @uptime
      msg = "System rebooted #{@uptime} seconds ago"
      if config[:warn]
        warning(msg)
      else
        critical(msg)
      end
    else
      ok("System has been up since #{Time.now - @uptime}")
    end
  end
end
