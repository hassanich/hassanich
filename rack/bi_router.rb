require 'pg'

module Rack
  class BIRouter
    LobsterString = '
<form action="/">
<textarea name="myTextBox" cols="50" rows="5">
</textarea>
<br />
<input type="submit" />
</form>
'

    LambdaLobster = lambda { |env|
      lobster = LobsterString
      if env[QUERY_STRING].include?("flip")
        href = "?"
      else
        href = "?flip"
      end

      content = ["<title>Lobstericious!</title>",
                 "<pre>", lobster, "</pre>",
                 "<a href='#{href}'>flip!</a>"]
      length = content.inject(0) { |a, e| a + e.size }.to_s
      [200, { CONTENT_TYPE => "text/html", CONTENT_LENGTH => length }, content]
    }

    def call(env)
      req = Request.new(env)
      p "req: #{req.params}"
      # case req.path_info
      #   when /hello/
      #     [200, {"Content-Type" => "text/html"}, [dbresult]]
      #   when /goodbye/
      #     [200, {"Content-Type" => "text/html"}, ["Goodbye Cruel World!"]]
      #   else
      #     [200, {"Content-Type" => "text/html"}, ["I'm Lost!"]]
      # end

      if req.GET["flip"] == "clear"
        lobster = "
<textarea cols=\"50\" rows=\"5\">
</textarea>

<table border=\"1\">
<tr>
<th>Table Header</th><th>Table Header</th>
</tr>
<tr>
<td>Table cell 1</td><td>Table cell 2</td>
</tr>
<tr>
<td>Table cell 3</td><td>Table cell 4</td>
</tr>
</table>

        "
        href = "?flip=exec"
      elsif req.GET["flip"] == "crash"
        raise "Lobster crashed"
      else
        lobster = LobsterString
        href = "?flip=clear"
      end

      res = Response.new
      res.write "<title>Lobstericious!</title>"
      res.write "<pre>"
      res.write lobster
      res.write "</pre>"
      res.write "<p><a href='#{href}'>Execute</a></p>"
      res.finish
    end

    def dbresult
      conn = PG.connect( user: 'cccuser', password: 'cccuser', dbname: 'donations_dev' )
      str = ''
      result = conn.exec( 'SELECT * FROM pg_stat_activity' )
      result.each {|r| str += r.to_s }
      str
    end
  end
end




