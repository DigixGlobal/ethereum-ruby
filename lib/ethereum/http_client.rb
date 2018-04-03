require 'net/http'
module Ethereum
  class HttpClient < Client
    attr_accessor :host, :port, :uri, :ssl
    
    class ConnectionError < StandardError; end

    def initialize(host, port, ssl = false, log = false)
      super(log)
      @host = host
      @port = port
      @ssl = ssl
      if ssl
        @uri = URI("https://#{@host}:#{@port}")
      else
        @uri = URI("http://#{@host}:#{@port}")
      end
    end

    def send_single(payload)
      http = ::Net::HTTP.new(@host, @port)
      if @ssl
        http.use_ssl = true
      end
      header = {'Content-Type' => 'application/json'}
      request = ::Net::HTTP::Post.new(uri, header)
      request.body = payload
      begin
        response = http.request(request)
      rescue EOFError, Errno::ECONNRESET, SocketError, Net::OpenTimeout => ex
        raise ConnectionError.new("[#{ex.class}] #{ex.message}")
      end
      if response.class == Net::HTTPOK
        if @use_cookie
          set_cookie_headers = response.get_fields('set-cookie')
          if set_cookie_headers.present?
            @cookie = set_cookie_headers.map{|str| str.split('; ').first}.join('; ')
          end
        end
        return response.body
      else
        raise ConnectionError.new("[#{response.class}] #{response.body}")
      end
    end

    def send_batch(batch)
      result = send_single(batch.to_json)
      begin
        result = JSON.parse(result)
      rescue JSON::ParserError => ex
        raise Ethereum::Client::ResponseFormatError.new("[#{[ex.class]}] #{ex.message}")
      end

      # Make sure the order is the same as it was when batching calls
      # See 6 Batch here http://www.jsonrpc.org/specification
      return result.sort_by! { |c| c['id'] }  
    end
  end

end
