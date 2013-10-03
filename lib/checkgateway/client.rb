require 'net/http'
require 'net/https'

require_relative "ach"
require_relative "consumer"

module CheckGateway
  class Client
    attr_accessor :test_mode, :debug, :version
    attr_reader :version, :login, :password, :test_url, :live_url, :ach_path, :consumer_path

    include ACH
    include Consumer

    def initialize(options={})
      @test_mode = true
      @debug = options[:debug]
      @version = options[:version] || "1.4.2.11"
      @login = options[:login]
      @password = options[:password]

      @test_url = options[:test_url]
      @live_url = options[:live_url]
      @ach_path = options[:ach_path]
      @consumer_path = options[:consumer_path]
    end

    def base_url
      test_mode ? test_url : live_url
    end

    def http
      puts "sending request to #{base_url}..." if debug
      uri = URI.parse(base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if test_mode
      http
    end
  end
end
