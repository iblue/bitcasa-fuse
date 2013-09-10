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
      r = get "/directory/"
      if r.code != 200
        raise "Could not get root node id"
      end
      @root_id = r.parsed_response[0]["path"].gsub('/','')
    end

    def logout!
      # Implement me
    end

    def ls(path = nil)
      path = '/' if path.nil?
      path += '/' if path[-1] != '/' # Ending slash needed for rqst

      # FIXME: Expire cache or things will get fucked up
      @@cache ||= {}
      if !@@cache[path]
        rqst_path = "/directory/#{@root_id}#{path}"
        puts "DEBUG: Cache miss on #{path} -> RQST to #{rqst_path}"
        r = get rqst_path
        if r.code != 200
          puts "DEBUG: Return code != 200"
          byebug
          return [] # FIXME?
        end

        @@cache[path] = r.parsed_response.map do |e|
          r = {}
          r[:type] = case e["type"]
                      when 0
                        :file
                      when 1
                        :dir
                      else
                        byebug
                        raise "Unknown type: #{e["type"]}"
                      end
          r[:mtime] = e["mtime"]
          r[:size]  = e["size"] if r[:type] == :file
          r[:name]  = e["name"]
          r
        end
      end

      return @@cache[path]
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
