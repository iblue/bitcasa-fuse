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
    end

    def logout!
      # Implement me
    end

    def ls(path = nil)
      raise "Not implemented" if !path.nil?
      entries = (get "/directory#{@root}").parsed_response.map do |e|
        r = {}
        r[:type] = case e["category"]
                    when "documents"
                      :file
                    when "folders"
                      :dir
                    else
                      raise "Unknown category: #{e["category"]}"
                    end
        r[:mtime] = e["mtime"]
        r[:size]  = e["size"] if r[:type] == :file
        r[:name]  = e["name"]
        r
      end
    end

    def root
      @root
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
