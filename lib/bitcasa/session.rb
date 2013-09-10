module Bitcasa
  class Session
    include HTTParty
    base_uri "https://my.bitcasa.com/"

    def initialize(username, password)
      # Get CSRF token and code parameter
      response = get "/login"
      if response.code != 200
        raise "Server response not ok"
      end
      html = Nokogiri::HTML(response)
      csrf_token = html.css("form input[name=csrf_token]")[0]["value"]
      code       = html.css("form input[name=code]")[0]["value"]

      # Login using these values
      response = post "/login", :user       => username,
                                :password   => password,
                                :csrf_token => csrf_token,
                                :code       => code,
                                :redirect   => "/" # Needed?
      if response.code == 500
        raise "Bwah fuck"
      end
      byebug
    end

    private
    # Convienience methods
    def post(*args)
      self.class.post *args
    end

    def get(*args)
      self.class.get *args
    end
  end
end
