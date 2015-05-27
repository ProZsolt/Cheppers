#!/usr/bin/env ruby

require 'aws-sdk'
require 'net/http'
require 'uri'
require 'optparse'

class Configuration
  class << self

    def setup options
      @@config = Hash.new
      load_config
      config_aws
      load_instances options
    end

    def instances
      @@instances
    end

    # Loading configuration from a file
    def load_config
      begin
        @@config_file = File.open('../keys/rootkey.csv', 'r')
      rescue Errno::ENOENT
        abort "AWS key file doesn't exist."
      end
      @@config_file.readlines.each do |line|
        /(\S+)(?:\s)*=(?:\s)*(\S+)/.match line.strip
        @@config[$1.to_sym] = $2
      end
    end

    # Configurating AWS
    def config_aws
      Aws.config.update({
        region: @@config[:AWSRegion],
        credentials: Aws::Credentials.new(@@config[:AWSAccessKeyId], @@config[:AWSSecretKey]),
      })
    end

    # Loading instances
    def load_instances options
      if options[:instance]
        @@instances = options[:instance]
      else
        @@instances = Aws::EC2::Client.new.describe_instances.reservations.map(&:instances).flatten.map(&:instance_id)
      end
    end

  end
end

class EC2Instance
  def initialize instance_id
    @instance = Aws::EC2::Instance.new instance_id
    @name = Hash[@instance.tags.map {|stuct| [stuct.to_h[:key], stuct.to_h[:value]]}]['Name'] # getting name from the tags
  end

  # Start the instance
  def start
    @instance.start
    begin
      @instance.wait_until_running
      puts "Instance #{@name or @instance.id} is running"
    rescue Aws::Waiters::Errors::WaiterFailed => error
      puts "Failed waiting for instance running: #{error.message}"
    end
  end

  # Stop the instance
  def stop
    @instance.stop
    begin
      @instance.wait_until_stopped
      puts "Instance #{@name or @instance.id} stopped"
    rescue Aws::Waiters::Errors::WaiterFailed => error
      puts "Failed waiting for instance stopping: #{error.message}"
    end
  end

  # Display the status of the instance
  def status
    state = @instance.state.to_hash[:name]
    puts "Instance #{@name or @instance.id} is #{state}"
    if state == 'running'
      uri = URI.parse 'http://' + @instance.public_dns_name
      begin
        response = Net::HTTP.get_response uri
      rescue
        response = nil
      end
      puts '    Drupal is running' if response and response.code == '200' and response.body.include? "<span>Powered by <a href=\"https://www.drupal.org\">Drupal</a></span>"
    end
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: script.rb [options]"

  opts.on('-i', '--instance i1, 12, i3', Array, 'Instance IDs') { |v| options[:instance] = v }
  opts.on('--start',  'Start the instances') { |v| options[:start] = v }
  opts.on('--stop',   'Stop the instances') { |v| options[:stop]  = v }
  opts.on('--status', 'Display the status of the instances')  { |v| options[:status]  = v }
end.parse!

if $0 == __FILE__
  raise OptionParser::MissingArgument, "--start OR --stop OR --status" if options[:start].nil? && options[:stop].nil? && options[:status].nil?
end

Configuration.setup options

Configuration.instances.each do |instance|
  i = EC2Instance.new instance
  if options[:start]
    i.start
  elsif options[:stop]
    i.stop
  elsif options[:status]
    i.status
  end
end