defmodule Dispatcher do
  use Matcher

  define_accept_types [
    text: [ "text/*" ],
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  get "/images/*path", %{ accept: %{ json: true } } do
    Proxy.forward conn, path, "http://resource/images/"
  end

  match "/images/:name", %{} do
    Proxy.forward conn, [name <> ".png"], "http://filehost/images/"
  end

  match "/*path", %{ last_call: true } do
    send_resp( conn, 404, "{ \"message\": \"Could not find response, see config/dispatcher/dispatcher.ex\", \"code\": 404 }" )
  end

  last_match()
end
