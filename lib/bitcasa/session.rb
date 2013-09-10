module Bitcasa
  class Session
    include HTTParty
    base_uri "https://my.bitcasa.com/"

    def initialize(username, password)
      # Get CSRF token, code parameter and session cookie
      response = get "/login"
      if response.code != 200
        raise "Server response not ok"
      end
      html = Nokogiri::HTML(response)
      csrf_token = html.css("form input[name=csrf_token]")[0]["value"]
      code       = html.css("form input[name=code]")[0]["value"]

      # Persist cookies (Yeah, this is ugly).
      cookie = response.headers['Set-Cookie']

      # Login using these values
      response = post "/login", :body => {
                                  :user       => username,
                                  :password   => password,
                                  :csrf_token => csrf_token,
                                  :code       => code,
                                  :redirect   => "/"},
                                :headers => {
                                  "Cookie" => cookie
                                }
      if response.code != 200
        raise "Could not login"
      end

      @session_cookie = cookie
      self.class.headers["Cookie"] = cookie

      # Get root node id
      @root = (get "/directory/").parsed_response[0]["path"]
      byebug
    end

    def logout!
      # Implement me
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
