defmodule Dispatcher do
  use Matcher

  define_accept_types [
    text: [ "text/*" ],
    image: ["image/*"],
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  match "/images/:name", %{ accept: %{ image: true } } do
    Proxy.forward conn, [name <> ".png"], "http://filehost/images/"
  end
   
  get "/images/*path", %{ accept: %{ json: true } } do
    Proxy.forward conn, path, "http://resource/images/"
  end

  match "/*path", %{ last_call: true } do
    send_resp( conn, 404, "{ \"message\": \"Could not find response, see config/dispatcher/dispatcher.ex\", \"code\": 404 }" )
  end

  last_match()
end
