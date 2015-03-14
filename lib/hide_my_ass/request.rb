class HideMyAss::Request
  def initialize proxies, options={}
    @proxies = proxies
    @options = options.merge!(method: :get)
  end

  def run base_url
    @proxies.each do |proxy|
      @options[:proxy] = "http://#{proxy[:host]}:#{proxy[:port]}"

      # Pass request to Typhoeus
      request = Typhoeus::Request.new(base_url, @options)
      request.on_complete do |response|
        # Return on successful http code
        if (200..300).member?(response.code)
          @response = response and hydra.abort
        end
      end

      # Queue parallel requests
      hydra.queue(request)
    end

    hydra.run

    # Return response saved on successful completion.
    @response
  end

  def hydra
    @hydra ||= begin
      opts = if @options[:max_concurrency]
        { :max_concurrency => @options[:max_concurrency] }
      end

      Typhoeus::Hydra.new(opts || {})
    end
  end
end